defmodule StackoverflowCloneG.Controller.Comment.Update do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Controller.Question.Helper, as: QH
  alias StackoverflowCloneG.Controller.Answer.Helper,   as: AH
  alias StackoverflowCloneG.Error.ResourceNotFoundError
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Error.BadRequestError

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  def update(%Conn{assigns: %{me:  %{"_id" => login_id}}, request: %Request{ body: new_cmt, path_info: path_info, path_matches: %{document_id: doc_id, id: cmt_id}}} = conn) do
    case new_cmt["body"] do
      ""  -> ErrorJson.json_by_error(conn, BadRequestError.new())
      nil -> ErrorJson.json_by_error(conn, BadRequestError.new())
      _   ->
                                    
        collection = case path_info do
          [ _, "question", _, _, _ ] -> "Question"
          [ _, "answer",   _, _, _ ] -> "Answer"
        end
                                        
        with_collection(conn, fn data -> 
          %{"data" => org_data} = data
          case Enum.fetch(Enum.filter(org_data["comments"], 
                          fn x -> x["id"] == cmt_id end), 0) do 
            {:ok, org_cmt_body} -> 
              if org_cmt_body["user_id"] == login_id do
                new_cmt_body = Map.merge(org_cmt_body, new_cmt)
                org_cmt_index = Enum.find_index(org_data["comments"], 
                fn x -> x["id"] == cmt_id end)
                new_cmt_lst = List.replace_at(org_data["comments"], org_cmt_index,new_cmt_body)
                new_data = Map.merge(org_data, %{"comments" => new_cmt_lst})
                req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: new_data}
                req = Dodai.UpdateDedicatedDataEntityRequest.new(
                    SD.default_group_id(), collection, doc_id, SD.root_key(), req_body)
                res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
                case res do
                  %Dodai.UpdateDedicatedDataEntitySuccess{body: doc} -> 
                    case collection do
                      "Question" -> Conn.json(conn, 200, QH.to_response_body(doc))
                      "Answer"   -> Conn.json(conn, 200, AH.to_response_body(doc))
                    end
                    
                  %Dodai.ResourceNotFound{}                            -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
                end
      
              else
                ErrorJson.json_by_error(conn, StackoverflowCloneG.Error.CredentialError.new())
              end
            :error      -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
          end 
        end)
    end
  end

  def with_collection(%Conn{request: %Request{path_info: path_info, path_matches: %{document_id: doc_id}}} = conn, f) do
    collection = case path_info do
      [ _, "question", _, _, _ ] -> "Question"
      [ _, "answer",   _, _, _ ] -> "Answer"
    end
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), collection, doc_id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end

end

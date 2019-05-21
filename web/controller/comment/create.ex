defmodule StackoverflowCloneG.Controller.Comment.Create do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Error.ResourceNotFoundError
  alias StackoverflowCloneG.Controller.Question.Helper
  alias StackoverflowCloneG.Error.BadRequestError

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  def create(%Antikythera.Conn{assigns: %{me: %{"_id" => user_id}}, request: %Antikythera.Request{body: body, path_info: path_info}} = conn) do
    case body["body"] do
      ""  -> ErrorJson.json_by_error(conn, BadRequestError.new())
      nil -> ErrorJson.json_by_error(conn, BadRequestError.new())
      _   ->
        with_answer(conn, fn contents ->
          org_data = contents["data"]

          comments = [%{
            "id" => RandomString.stream(:alphanumeric) |> Enum.take(20) |> List.to_string,
            "user_id" => user_id,
            "body" => body["body"],
            "create_at" => Antikythera.Time.to_iso_timestamp(Antikythera.Time.now()),
          }]
          comments_new = contents["data"]["comments"] ++ comments

          new_data = Map.merge(org_data, %{"comments" => comments_new})
          req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: new_data}

          search_info = case path_info do
            [_,"question",_,_] -> "Question"
            [_,"answer",_,_] -> "Answer"
          end
          [_,_,search_id,_] = path_info
          req = Dodai.UpdateDedicatedDataEntityRequest.new(
            SD.default_group_id(),
            search_info, 
            search_id, 
            SD.root_key(),
            req_body)

          res = Sazabi.G2gClient.send(
            conn.context, 
            SD.app_id(), 
            req)

          case res do
            %Dodai.UpdateDedicatedDataEntitySuccess{body: doc}   -> Conn.json(conn, 200, Helper.to_response_body(doc))
            %Dodai.ResourceNotFound{}                            -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
          end
        end)
    end
  end

  def with_answer(%Antikythera.Conn{request: %Antikythera.Request{path_info: path_info}} = conn, f) do
    search_info = case path_info do
      [_,"question",_,_] -> "Question"
      [_,"answer",_,_] -> "Answer"
    end
    [_,_,search_id,_] = path_info

    req = Dodai.RetrieveDedicatedDataEntityRequest.new(
      SD.default_group_id(),
      search_info,
      search_id,
      SD.root_key())
    res = Sazabi.G2gClient.send(
      conn.context,
      SD.app_id(),
      req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body}  -> f.(body)
      %Dodai.ResourceNotFound{}                              -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end

defmodule StackoverflowCloneG.Controller.Answer.Update do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Controller.Answer.Helper
  alias StackoverflowCloneG.Error.ResourceNotFoundError
  alias StackoverflowCloneG.Dodai, as: SD

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  def update(%Conn{request: %Request{path_matches: %{id: id}}, assigns: %{me: %{"_id" => login_id}},request: %Antikythera.Request{body: %{"body" => body}}} = conn) do
    # 指定されたidをもつquestionを取得する
    with_answer(conn, fn answer ->       
      %{"data" => org_data} = answer
      %{"data" => %{"user_id" => user_id}} = answer
      if user_id == login_id do
        ### 1. dodaiに対してrequestするrequest bodyを作成する
        new_data = Map.merge(org_data, %{"body" => body})
        req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: new_data}
        req = Dodai.UpdateDedicatedDataEntityRequest.new(
            SD.default_group_id(), "Answer", id, SD.root_key(), req_body)

        ### 2. dodaiに対してrequestするためのstructを作る
        res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

        ### 3. クライアントにレスポンスを返す
        case res do
          %Dodai.UpdateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
          %Dodai.ResourceNotFound{}                            -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
        end
        
      else
        ## 一致しない場合、下記のようにエラーを返す
        ErrorJson.json_by_error(conn, StackoverflowCloneG.Error.CredentialError.new())
      end
    end)
  end        

  def with_answer(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: answer_id}}} = conn, f) do
      req = Dodai.RetrieveDedicatedDataEntityRequest.new(
        SD.default_group_id(), "Answer", answer_id, SD.root_key())
      res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
      case res do
        %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
        %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
      end  
  end
end

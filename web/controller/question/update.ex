defmodule StackoverflowCloneG.Controller.Question.Update do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Controller.Question.Helper
  alias StackoverflowCloneG.Error.ResourceNotFoundError
  alias StackoverflowCloneG.Dodai, as: SD

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  #def update(%Antikythera.Conn{request: %Antikythera.Request{body: %{"title" => title, "body" => body}, path_matches: %{id: id }}} = conn) do
  def update(%Conn{request: %Request{path_matches: %{id: id}}, assigns: %{me: %{"_id" => login_id}},request: %Antikythera.Request{body: %{"body" => body, "title" => title}}} = conn) do
    with_question(conn, fn question -> 
      %{"data" => org_data} = question
      %{"data" => %{"user_id" => user_id}} = question

      if user_id == login_id do
        ### 1. dodaiに対してrequestするrequest bodyを作成する
        new_data = Map.merge(org_data, %{"title" => title,"body" => body})
        req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: new_data}
        req = Dodai.UpdateDedicatedDataEntityRequest.new(
              SD.default_group_id(),
              "Question", 
              id, 
              SD.root_key(),
              req_body)
        ### 2. dodaiに対してrequestするためのstructを作る
        res = Sazabi.G2gClient.send(
              conn.context, 
              SD.app_id(), 
              req)
        ### 3. クライアントにレスポンスを返す(dodaiのresponse bodyがいつもと違うことに注意)
        # Conn.json(conn, 200, %{"message" => "書き換えが必要です"})
        IO.inspect res
        case res do
          %Dodai.UpdateDedicatedDataEntitySuccess{body: doc} -> 
            Conn.json(conn, 200, Helper.to_response_body(doc))
          %Dodai.ResourceNotFound{}                            -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
        end
      else
        ErrorJson.json_by_error(conn, StackoverflowCloneG.Error.CredentialError.new())
      end
    end)
  end
  
  def with_question(%Conn{request: %Request{path_matches: %{id: id}}} = conn, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end

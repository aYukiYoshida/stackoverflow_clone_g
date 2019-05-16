defmodule StackoverflowCloneG.Controller.Question.Create do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Controller.Question.Helper
  alias StackoverflowCloneG.Error.ResourceNotFoundError

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  def create(%Antikythera.Conn{assigns: %{me: %{"_id" => id}}, request: %Antikythera.Request{body: %{"body" => body, "title" => title}}} = conn) do
    data = %{"title"=>title,"body"=>body}
    req_body = %Dodai.CreateDedicatedDataEntityRequestBody{owner: id, data: data}
    req = Dodai.CreateDedicatedDataEntityRequest.new(
      SD.default_group_id(),
      "Question",
      SD.root_key(),
      req_body)
    
    res = Sazabi.G2gClient.send(
      conn.context,
      SD.app_id(),
      req)

    case res do
      %Dodai.CreateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 201, Helper.to_response_body(doc))
      %Dodai.BadRequest{}                                -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end

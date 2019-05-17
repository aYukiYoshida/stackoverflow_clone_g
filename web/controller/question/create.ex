defmodule StackoverflowCloneG.Controller.Question.Create do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Controller.Question.Helper
  alias StackoverflowCloneG.Error.BadRequestError

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  def create(%Antikythera.Conn{assigns: %{me: %{"_id" => id}}, request: %Antikythera.Request{body: %{"body" => body, "title" => title}}} = conn) do
    data = %{
      "title" => title,
      "body" => body,
      "user_id" => id,
      "comments" => [],
      "like_voter_ids" => [],
      "dislike_voter_ids" => [],
      }

    req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: data}
    req = Dodai.CreateDedicatedDataEntityRequest.new(
      SD.default_group_id(),
      "Question",
      SD.root_key(),
      req_body
      )
    
    res = Sazabi.G2gClient.send(
      conn.context,
      SD.app_id(),
      req
      )

    case res do
      %Dodai.CreateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
      %Dodai.BadRequest{}                                -> ErrorJson.json_by_error(conn, BadRequestError.new())
    end
  end
end

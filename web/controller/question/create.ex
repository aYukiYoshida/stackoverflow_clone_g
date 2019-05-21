defmodule StackoverflowCloneG.Controller.Question.Create do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Controller.Question.Helper
  alias StackoverflowCloneG.Error.BadRequestError
  alias StackoverflowCloneG.Error.ResourceNotFoundError

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  def create(%Antikythera.Conn{assigns: %{me: %{"_id" => id}}, request: %Antikythera.Request{body: body}} = conn) do
    case body do
      %{"body" => inner_body, "title" => title} ->
        if inner_body == "" or title == "" or inner_body == nil or title == nil do
          ErrorJson.json_by_error(conn, BadRequestError.new())
        else
          data = %{
            "title" => title,
            "body" => inner_body,
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
            req_body)
          
          res = Sazabi.G2gClient.send(
            conn.context,
            SD.app_id(),
            req)

          case res do
            %Dodai.CreateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
            %Dodai.ResourceNotFound{}                          -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
          end
        end
      _ ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
    end
  end
end

defmodule StackoverflowCloneG.Controller.Answer.Create do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Controller.Answer.Helper
  alias StackoverflowCloneG.Error.ResourceNotFoundError
  alias StackoverflowCloneG.Error.BadRequestError

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  def create(%Antikythera.Conn{assigns: %{me: %{"_id" => user_id}}, request: %Antikythera.Request{body: body}} = conn) do
    case body do
      %{"body" => inner_body, "question_id" => question_id} ->
        if inner_body == "" or question_id == "" or inner_body == nil or question_id == nil do
          ErrorJson.json_by_error(conn, BadRequestError.new())
        else
          with_answer(conn, fn _answer ->
            data = %{
              "body" => inner_body,
              "question_id" => question_id,
              "user_id" => user_id,
              "comments" => [],
            }

            req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: data}
            req = Dodai.CreateDedicatedDataEntityRequest.new(
              SD.default_group_id(),
              "Answer",
              SD.root_key(),
              req_body)
            
            res = Sazabi.G2gClient.send(
              conn.context,
              SD.app_id(),
              req)

            case res do
              %Dodai.CreateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
              _                                                  -> ErrorJson.json_by_error(conn, BadRequestError.new())
            end
          end)
        end
      _ ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
    end
  end

  def with_answer(%Antikythera.Conn{request: %Antikythera.Request{body: %{"question_id" => question_id}}} = conn, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(
      SD.default_group_id(),
      "Question",
      question_id,
      SD.root_key())
    res = Sazabi.G2gClient.send(
      conn.context,
      SD.app_id(),
      req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{}  -> f.(conn)
      %Dodai.ResourceNotFound{}                    -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end

defmodule StackoverflowCloneG.Controller.Question.Show do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Controller.Question.Helper
  alias StackoverflowCloneG.Error.ResourceNotFoundError

  def show(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: id}}} = conn) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(
      SD.default_group_id(),
      "Question",
      id,
      SD.root_key())

    res = Sazabi.G2gClient.send(
      conn.context,
      SD.app_id(),
      req)

    IO.inspect res
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
      %Dodai.ResourceNotFound{}                            -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end

  end
end
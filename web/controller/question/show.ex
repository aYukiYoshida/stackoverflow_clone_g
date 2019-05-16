defmodule StackoverflowCloneG.Controller.Question.Show do
  use StackoverflowCloneG.Controller.Application

  def show(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: id}}} = conn) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(
      StackoverflowCloneG.Dodai.default_group_id(),
      "Question",
      id,
      StackoverflowCloneG.Dodai.root_key())

    res = Sazabi.G2gClient.send(
      conn.context,
      StackoverflowCloneG.Dodai.app_id(),
      req)

    IO.inspect res.body
    res_body = %{
      Title: res.body["data"]["title"],
      Body: res.body["data"]["body"],
    }
    Conn.json(conn, 200, res_body)
  end
end

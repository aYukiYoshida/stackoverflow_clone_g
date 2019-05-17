defmodule StackoverflowCloneG.Controller.Answer.Index do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Controller.Answer.Helper

  def index(conn) do
    query = %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: %{},
      sort:  %{"_id" => 1},
    }
    req = Dodai.RetrieveDedicatedDataEntityListRequest.new(
      SD.default_group_id(),
      "Answer",
      SD.root_key(),
      query
      )
    %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = Sazabi.G2gClient.send(
      conn.context,
      SD.app_id(),
      req
      )
    Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
  end
end

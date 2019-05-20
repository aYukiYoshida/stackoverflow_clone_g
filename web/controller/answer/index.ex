use Croma

defmodule StackoverflowCloneG.Controller.Answer.IndexRequestParams do
  use Croma.Struct, fields: [
    user_id:  Croma.TypeGen.nilable(Croma.String),
    question_id: Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneG.Controller.Answer.Index do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Error.BadRequestError
  alias StackoverflowCloneG.Controller.Answer.{Helper, IndexRequestParams}

  def index(%Antikythera.Conn{request: %Antikythera.Request{query_params: query_params}} = conn) do
    case IndexRequestParams.new(query_params) do
      {:error, _} ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        query = convert_to_dodai_req_query(validated)
        req = Dodai.RetrieveDedicatedDataEntityListRequest.new(
          SD.default_group_id(),
          "Answer",
          SD.root_key(),
          query)
        %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = Sazabi.G2gClient.send(
          conn.context,
          SD.app_id(),
          req)
        Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
    end
  end

  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t]) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    query = Map.from_struct(params)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Map.new()

    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
      sort:  %{"_id" => 1}
    }
  end
end

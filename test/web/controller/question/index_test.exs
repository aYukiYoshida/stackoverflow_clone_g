defmodule StackoverflowCloneG.Controller.Question.IndexTest do
  use StackoverflowCloneG.CommonCase
  alias Dodai.RetrieveDedicatedDataEntityListRequestQuery, as: Query
  alias Sazabi.G2gClient
  alias StackoverflowCloneG.Controller.Question.Index
  alias StackoverflowCloneG.Controller.Question.IndexRequestParams
  alias StackoverflowCloneG.TestData.QuestionData

  @api_prefix "/v1/question"

  test "index/1 " <>
    "should return questions" do
    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      assert req.query == %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
        limit: nil,
        skip:  nil,
        query: %{},
        sort:  %{"_id" => 1}
      }

      %Dodai.RetrieveDedicatedDataEntityListSuccess{body: [QuestionData.dodai()]}
    end)

    res = Req.get(@api_prefix)
    assert res.status               == 200
    assert Poison.decode!(res.body) == [QuestionData.gear()]
  end
  
  test "index/1 " <> "should build query" do
    params_list = [
      {%IndexRequestParams{user_id: nil},       %Query{query: %{},                            sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: "user_id"}, %Query{query: %{"data.user_id" => "user_id"}, sort: %{"_id" => 1}}},
    ]
    Enum.each(params_list, fn {params, expected} ->
      assert Index.convert_to_dodai_req_query(params) == expected
    end)
  end
end

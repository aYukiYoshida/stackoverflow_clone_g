defmodule StackoverflowCloneG.Controller.Answer.IndexTest do
  use StackoverflowCloneG.CommonCase
  alias StackoverflowCloneG.TestData.AnswerData
  alias StackoverflowCloneG.Controller.Answer.Index
  alias StackoverflowCloneG.Controller.Answer.IndexRequestParams
  alias Dodai.RetrieveDedicatedDataEntityListRequestQuery, as: Query

  @api_prefix "/v1/answer"

  test "index/1 " <>
    "should return answers"do
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      assert req.query == %Query{
        limit: nil,
        skip:  nil,
        query: %{},
        sort:  %{"_id" => 1}
      }

      %Dodai.RetrieveDedicatedDataEntityListSuccess{body: [AnswerData.dodai()]}
    end)

    res = Req.get(@api_prefix)
    assert res.status               == 200
    assert Poison.decode!(res.body) == [AnswerData.gear()]
  end

  test "index/1" <>
    "should build query" do
    params_list = [
      {%IndexRequestParams{user_id: nil, question_id: nil}, %Query{query: %{}, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: "user_id", question_id: nil}, %Query{query: %{"data.user_id" => "user_id"}, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: nil, question_id: "question_id"}, %Query{query: %{"data.question_id" => "question_id"}, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: "user_id", question_id: "question_id"}, %Query{query: %{"data.user_id" => "user_id", "data.question_id" => "question_id"}, sort: %{"_id" => 1}}},
    ]
    Enum.each(params_list, fn {params, expected} ->
      assert Index.convert_to_dodai_req_query(params) == expected
    end)
  end
end

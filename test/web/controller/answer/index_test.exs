defmodule StackoverflowCloneG.Controller.Answer.IndexTest do
  use StackoverflowCloneG.CommonCase
  alias StackoverflowCloneG.TestData.AnswerData

  @api_prefix "/v1/answer"

  test "index/1 " <>
    "should return answers"do
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      assert req.query == %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
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
end

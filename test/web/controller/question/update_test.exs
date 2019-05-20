defmodule StackoverflowCloneG.Controller.Question.UpdateTest do
  use StackoverflowCloneG.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneG.TestData.QuestionData

  @api_prefix "/v1/question/question_id"
  @header     %{}
  @body       %{"title" => "new title", "body" => "new body"}

  test "update/1 " <> "should update question" do
    :meck.expect(StackoverflowCloneG.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, StackoverflowCloneG.TestData.UserData.dodai())
    end)
    
    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
          # retrieve_reqについて必要に応じてassertする
          assert retrieve_req.id == "question_id"
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{}   = update_req   ->
          # update_reqについての必要に応じてassertする
          assert update_req.body.data["body"]  == "new body"
          assert update_req.body.data["title"] == "new title"
          %Dodai.UpdateDedicatedDataEntitySuccess{body: StackoverflowCloneG.TestData.QuestionData.dodai()}
        end
    end)

    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == QuestionData.gear()
  end
end

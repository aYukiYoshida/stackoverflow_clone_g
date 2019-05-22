defmodule StackoverflowCloneG.Controller.Comment.CreateTest do
  use StackoverflowCloneG.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneG.TestData.UserData
  alias StackoverflowCloneG.TestData.QuestionData
  alias StackoverflowCloneG.TestData.AnswerData

  @api_prefix_q  "/v1/question/question_id/comment"
  @api_prefix_a  "/v1/answer/answer_id/comment"
  @header     %{}
  @body       %{"body" => "body"}

  test "create/1 " <> "should create comment" do
    :meck.expect(StackoverflowCloneG.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, UserData.dodai())
    end)

    :meck.expect(RandomString, :take, fn(_, _) ->
      "abcdefghijabcdefghij"
    end)

    :meck.expect(Antikythera.Time, :to_iso_timestamp, fn(_) ->
      "2019-05-22T00:00:00.000+00:00"
    end)

    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
          case retrieve_req.data_collection_name do
            "Question" ->
              assert retrieve_req.id == "question_id"
              %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
            "Answer" -> 
              assert retrieve_req.id == "answer_id"
              %Dodai.RetrieveDedicatedDataEntitySuccess{body: AnswerData.dodai()}
          end
          
        %Dodai.UpdateDedicatedDataEntityRequest{}   = update_req   ->
          case update_req.data_collection_name do
            "Question" ->
              assert update_req.id == "question_id"
              assert List.last(update_req.body.data["comments"]) == %{
                "body" => "body",
                "create_at" => "2019-05-22T00:00:00.000+00:00",
                "id" => "abcdefghijabcdefghij",
                "user_id" => "user_id",
              }
              %Dodai.UpdateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
            "Answer" -> 
              assert update_req.id == "answer_id"
              assert List.last(update_req.body.data["comments"]) == %{
                "body" => "body",
                "create_at" => "2019-05-22T00:00:00.000+00:00",
                "id" => "abcdefghijabcdefghij",
                "user_id" => "user_id",
              }
              %Dodai.UpdateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
          end
      end
    end)

    res = Req.post_json(@api_prefix_q, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == QuestionData.gear()
    
    res = Req.post_json(@api_prefix_a, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == AnswerData.gear()
  end

  test "create/1 when user did not login " <>
  "it returns InvalidCredential" do
    res = Req.post_json(@api_prefix_q, @body, @header)
    assert res.status               == 401
    assert Poison.decode!(res.body) == %{
      "code"        => "401-00",
      "description" => "The given credential is invalid.",
      "error"       => "InvalidCredential",
    }
    res = Req.post_json(@api_prefix_a, @body, @header)
    assert res.status               == 401
    assert Poison.decode!(res.body) == %{
      "code"        => "401-00",
      "description" => "The given credential is invalid.",
      "error"       => "InvalidCredential",
    }
  end
end

defmodule StackoverflowCloneG.Controller.Answer.CreateTest do
  use StackoverflowCloneG.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneG.TestData.AnswerData
  alias StackoverflowCloneG.TestData.QuestionData
  alias StackoverflowCloneG.TestData.UserData

  @api_prefix "/v1/answer"
  @header     %{}
  @body       %{"body" => "本文", "question_id" => "question_id"}

  test "create/1 should create answer" do
    :meck.expect(StackoverflowCloneG.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, UserData.dodai())
    end)

    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
          # retrieve_reqについて必要に応じてassertする
          assert retrieve_req.id == "question_id"
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.CreateDedicatedDataEntityRequest{}   = create_req   ->
          # create_reqについての必要に応じてassertする
          assert create_req.body == %Dodai.CreateDedicatedDataEntityRequestBody{
            _id:  nil,
            data: %{"body" => "本文", "question_id" => "question_id", "comments" => [], "user_id" => "user_id"},
          }
          %Dodai.CreateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == AnswerData.gear()
  end

  test "create/1 when request body is invalid " <>
    "it returns BadRequestError" do
    :meck.expect(StackoverflowCloneG.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, UserData.dodai())
    end)
    invalid_bodies = [
      %{                    "question" => "question_id"},
      %{"body" => "",       "question" => "question_id"},
      %{"body" => "本文"},
      %{"body" => "本文",    "question" => ""},
    ]
    Enum.each(invalid_bodies, fn body ->
      res = Req.post_json(@api_prefix, body, @header)
      assert res.status               == 400
      assert Poison.decode!(res.body) == %{
        "code"        => "400-06",
        "description" => "Unable to understand the request.",
        "error"       => "BadRequest",
      }
    end)
  end

  test "create/1 when user did not login " <>
    "it returns InvalidCredential" do
    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 401
    assert Poison.decode!(res.body) == %{
      "code"        => "401-00",
      "description" => "The given credential is invalid.",
      "error"       => "InvalidCredential",
    }
  end

end

defmodule StackoverflowCloneG.Controller.Question.CreateTest do
  use StackoverflowCloneG.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneG.TestData.QuestionData

  @api_prefix "/v1/question"
  @header     %{}
  @body       %{"title" => "title", "body" => "body"}

  test "create/1 " <> "should create question" do
    :meck.expect(StackoverflowCloneG.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, StackoverflowCloneG.TestData.UserData.dodai())
    end)
    
    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      %Dodai.CreateDedicatedDataEntityRequestBody{data: %{"user_id" => user_id }} = req.body
       
      assert req.body == %Dodai.CreateDedicatedDataEntityRequestBody{
        data: %{"title" => "title", "body" => "body",
        "user_id" => user_id,
        "comments" => [],
        "like_voter_ids" => [],
        "dislike_voter_ids" => [],
        },
      }
      %Dodai.CreateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == QuestionData.gear()
  end

  # test "create/1 " <>
  #   "when request body is invalid " <>
  #   "it returns BadRequestError" do
  #   invalid_bodies = [
  #     %{                                       "body" => "body"},
  #     %{"title" => "",                         "body" => "body"},
  #     %{"title" => String.duplicate("a", 101), "body" => "body"},
  #     %{"title" => "body"},
  #     %{"title" => "body",                     "body" => ""},
  #     %{"title" => "body",                     "body" => String.duplicate("a", 51)},
  #   ]

  #   Enum.each(invalid_bodies, fn body ->
  #     res = Req.post_json(@api_prefix, body, @header)
  #     assert res.status               == 400
  #     assert Poison.decode!(res.body) == %{
  #       "code"        => "400-06",
  #       "description" => "Unable to understand the request.",
  #       "error"       => "BadRequest",
  #     }
  #   end)
  # end
end

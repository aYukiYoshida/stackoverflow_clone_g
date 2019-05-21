defmodule StackoverflowCloneG.Controller.Answer.UpdateTest do
  use StackoverflowCloneG.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneG.TestData.AnswerData
  alias StackoverflowCloneG.TestData.UserData

  @api_prefix "/v1/answer/answer_id"
  @header     %{}
  @body       %{"body" => "new body"}

  test "update/1 should update answer " do
    :meck.expect(StackoverflowCloneG.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, UserData.dodai())
    end)

    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
          # retrieve_reqについて必要に応じてassertする
          assert retrieve_req.id == "answer_id"
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: AnswerData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{}   = update_req   ->
          # update_reqについての必要に応じてassertする
          assert update_req.body.data["body"] == "new body"
          %Dodai.UpdateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == AnswerData.gear()
  end

  test "update/1 when user did not login " <>
    "it returns InvalidCredentialError" do
    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 401
    assert Poison.decode!(res.body) == %{
      "code"        => "401-00",
      "description" => "The given credential is invalid.",
      "error"       => "InvalidCredential",
    }
  end

  test "update/1 when specified answer is not found " <>
    "it returns ResourceNotFoundError" do
    :meck.expect(StackoverflowCloneG.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, UserData.dodai())
    end)
    :meck.expect(G2gClient, :send, fn(_, _, _) -> %Dodai.ResourceNotFound{} end)

    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 404
    assert Poison.decode!(res.body) == %{
      "code"        => "404-04",
      "description" => "The resource does not exist in the database.",
      "error"       => "ResourceNotFound",
    }
  end
end

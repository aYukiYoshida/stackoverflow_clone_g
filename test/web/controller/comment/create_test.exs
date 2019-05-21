defmodule StackoverflowCloneG.Controller.Comment.CreateTest do
  use StackoverflowCloneG.CommonCase
  alias StackoverflowCloneG.TestData.UserData

  test "create/1 " <> "should create question" do
    :meck.expect(StackoverflowCloneG.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, UserData.dodai())
    end)


  end
end

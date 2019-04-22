use Croma

defmodule StackoverflowCloneG.Controller.Root.Index do
  use StackoverflowCloneG.Controller.Application

  defun index(conn :: Conn.t) :: Conn.t do
    Conn.render(conn, 200, "root/index", [])
  end
end

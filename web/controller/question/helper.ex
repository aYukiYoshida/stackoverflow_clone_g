use Croma

defmodule StackoverflowCloneG.Controller.Question.Helper do
  use StackoverflowCloneG.Controller.Application

  @collection_name "Question"

  defun collection_name() :: String.t do
    @collection_name
  end

  defun to_response_body(doc :: map) :: map do
    Map.merge(doc["data"], %{
      "id"         => doc["_id"],
      "created_at" => doc["createdAt"],
      "owner"      => doc["owner"]
    })
  end
end

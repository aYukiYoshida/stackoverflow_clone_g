defmodule StackoverflowCloneA.Controller.Answer.Helper do
    use StackoverflowCloneA.Controller.Application
  
    def to_response_body(doc) do
      base_map = %{
        "id"         => doc["_id"],
        "created_at" => doc["created_at"],
      }
      Map.merge(doc["data"], base_map)
    end
  end
  
defmodule StackoverflowCloneG.Controller.Answer.Helper do
    use StackoverflowCloneG.Controller.Application
  
    def to_response_body(doc) do
      base_map = %{
        "id"         => doc["_id"],
        "created_at" => doc["createdAt"],
      }
      Map.merge(doc["data"], base_map)
    end
  end
  
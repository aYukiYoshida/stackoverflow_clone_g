use Croma

defmodule StackoverflowCloneG.Model.Answer do
  @moduledoc """
  Answer of StackoverflowCloneG app.
  """

  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,3000}\z/u
  end

  use AntikytheraAcs.Dodai.Model.Datastore, data_fields: [
    body:        Body,
    user_id:     StackoverflowCloneG.DodaiId,
    question_id: StackoverflowCloneG.DodaiId,
    comments:    StackoverflowCloneG.CommentList,
  ]
end

use Croma

defmodule StackoverflowCloneG.Comment do
  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,1000}\z/u
  end
  use Croma.Struct, recursive_new?: true, fields: [
    id:         StackoverflowCloneG.DodaiId,
    body:       Body,
    user_id:    StackoverflowCloneG.DodaiId,
    created_at: Croma.String,
  ]
end

defmodule StackoverflowCloneG.CommentList do
  use Croma.SubtypeOfList, elem_module: StackoverflowCloneG.Comment
end

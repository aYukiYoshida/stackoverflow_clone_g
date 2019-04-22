use Croma

defmodule StackoverflowCloneG.NonEmptyString do
  use Croma.SubtypeOfString, pattern: ~r"\A.+\Z"
end

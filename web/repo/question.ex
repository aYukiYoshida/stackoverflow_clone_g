use Croma

defmodule StackoverflowCloneG.Repo.Question do
  use AntikytheraAcs.Dodai.Repo.Datastore, [
    datastore_models: [StackoverflowCloneG.Model.Question],
  ]
end

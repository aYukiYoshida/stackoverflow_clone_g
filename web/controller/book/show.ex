use Croma

defmodule StackoverflowCloneG.Controller.Book.Show do
  use StackoverflowCloneG.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Error.ResourceNotFoundError
  alias StackoverflowCloneG.Controller.Book.Helper

  defun show(%Conn{request: %Request{path_matches: %{id: id}}, context: context} = conn) :: Conn.t do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), Helper.collection_name(), id, SD.root_key())
    res = G2gClient.send(context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
      %Dodai.ResourceNotFound{}                            -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end

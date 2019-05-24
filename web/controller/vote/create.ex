defmodule StackoverflowCloneG.Controller.Vote.Create do
  use StackoverflowCloneG.Controller.Application
  alias StackoverflowCloneG.Dodai, as: SD
  alias StackoverflowCloneG.Error.ResourceNotFoundError
  alias StackoverflowCloneG.Error.BadRequestError
  alias StackoverflowCloneG.Controller.Question.Helper, as: QH

  plug StackoverflowCloneG.Plug.FetchMe, :fetch, []

  def create(%Antikythera.Conn{assigns: %{me: %{"_id" => user_id}}, request: %Antikythera.Request{path_info: [_,search_type,search_id,_,vote_type]}} = conn) do
    with_collection(conn, fn contents ->
      vote_input = case vote_type do
        "like_vote"    -> "like_voter_ids"
        "dislike_vote" -> "dislike_voter_ids"
      end
      vote_opp = case vote_type do
        "like_vote"    -> "dislike_voter_ids"
        "dislike_vote" -> "like_voter_ids"
      end
      search_info = case search_type do
        "question" -> "Question"
        "answer"   -> "Answer"
      end

      # 二重投票を防止
      if user_id in contents["data"][vote_input] do
        ErrorJson.json_by_error(conn, BadRequestError.new())
      else
        org_data = contents["data"]
        vote_id = [user_id]

        # 反対側idがある場合は、まず反対側のid削らなければいけない
        if user_id in contents["data"][vote_opp] do
          vote_modify = contents["data"][vote_opp] -- vote_id
          vote_new = contents["data"][vote_input] ++ vote_id
          new_data = Map.merge(org_data, %{vote_input => vote_new, vote_opp => vote_modify})

          req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: new_data}
          req = Dodai.UpdateDedicatedDataEntityRequest.new(
            SD.default_group_id(),
            search_info, 
            search_id, 
            SD.root_key(),
            req_body)
          res = Sazabi.G2gClient.send(
            conn.context, 
            SD.app_id(), 
            req)
          case res do
            %Dodai.UpdateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, QH.to_response_body(doc))
            _                                                  -> ErrorJson.json_by_error(conn, BadRequestError.new())
          end

        # 反対側idが無い場合
        else
          vote_new = contents["data"][vote_input] ++ vote_id
          new_data = Map.merge(org_data, %{vote_input => vote_new})

          req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: new_data}
          req = Dodai.UpdateDedicatedDataEntityRequest.new(
            SD.default_group_id(),
            search_info, 
            search_id, 
            SD.root_key(),
            req_body)
          res = Sazabi.G2gClient.send(
            conn.context, 
            SD.app_id(), 
            req)
          case res do
            %Dodai.UpdateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, QH.to_response_body(doc))
            _                                                  -> ErrorJson.json_by_error(conn, BadRequestError.new())
          end
        end
      end
    end)
  end

  # 指定してるQuestionあるいはAnswerが存在するかどうかをチェック
  def with_collection(%Antikythera.Conn{request: %Antikythera.Request{path_info: [_,search_type,search_id,_,_]}} = conn, f) do
    search_info = case search_type do
      "question" -> "Question"
      "answer"   -> "Answer"
    end
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(
      SD.default_group_id(),
      search_info,
      search_id,
      SD.root_key())
    res = Sazabi.G2gClient.send(
      conn.context,
      SD.app_id(),
      req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body}  -> f.(body)
      %Dodai.ResourceNotFound{}                              -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end
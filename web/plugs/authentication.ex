defmodule WorkoutDemo.Authentication do
  import Plug.Conn
  alias WorkoutDemo.{Repo, User, Session}
  import Ecto.Query, only: [from: 2]
  require Logger

  def init(options), do: options

  def call(conn, _opts) do
    case find_user(conn) do
      {:ok, user} -> assign(conn, :current_user, user)
      _otherwise  -> auth_error!(conn)
    end
  end

  defp find_user(conn) do
    with auth_header = get_req_header(conn, "authorization"),
         {:ok, token}   <- parse_token(auth_header),
         {:ok, session} <- find_session_by_token(token),
    do:  find_user_by_session(session)
  end

  defp parse_token(["Bearer token=" <> token]) do
    {:ok, String.replace(token, "\"", "")}
  end
  defp parse_token(_non_token_header), do: :error

  defp find_session_by_token(token) do
    case Repo.one(from s in Session, where: s.token == ^token) do
      nil     -> :error
      session -> {:ok, session}
    end
  end

  defp find_user_by_session(session) do
    case Repo.get(User, session.user_id) do
      nil  -> :error
      user -> {:ok, user}
    end
  end

  defp auth_error!(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, "{ \"error\": \"Not Authorized\"}") |> halt()
  end
end
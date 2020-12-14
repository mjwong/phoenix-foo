defmodule FooWeb.PageController do
  use FooWeb, :controller
  # import FooWeb.Router.Helpers
  alias HelloWeb.Router.Helpers, as: Routes

  alias Foo.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/") 

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end

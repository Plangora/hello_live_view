defmodule HelloLiveViewWeb.UserShowTest do
  use HelloLiveViewWeb.LiveViewCase
  alias HelloLiveView.{Accounts, Fixtures}

  setup do: {:ok, user: Fixtures.user_fixture()}

  test "user will show", %{conn: conn, user: user} do
    {:ok, _view, html} = live(conn, Routes.user_path(conn, :show, user))
    assert html =~ user.username
  end

  test "updated user will show updates on the view", %{conn: conn, user: user} do
    {:ok, view, _html} = live(conn, Routes.user_path(conn, :show, user))
    {:ok, user} = Accounts.update_user(user, %{username: "new_username"})
    assert render(view) =~ user.username
  end

  test "deleted user will redirect to index page", %{conn: conn, user: user} do
    {:ok, view, _html} = live(conn, Routes.user_path(conn, :show, user))
    users_path = Routes.user_path(conn, :index)

    assert_redirect(view, ^users_path, fn ->
      assert {:ok, _user} = Accounts.delete_user(user)
    end)
  end
end

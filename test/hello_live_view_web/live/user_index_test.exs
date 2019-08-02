defmodule HelloLiveViewWeb.UserIndexTest do
  use HelloLiveViewWeb.LiveViewCase
  alias HelloLiveView.{Accounts, Fixtures}

  test "created user will show up on the view", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.user_path(conn, :index))
    user = Fixtures.user_fixture()
    refute html =~ user.username
    assert render(view) =~ ~s(<a href="#{Routes.live_path(conn, HelloLiveViewWeb.UserShow, user)}">#{user.username}</a>)
  end

  test "deleted user will not show up on the view", %{conn: conn} do
    user = Fixtures.user_fixture()
    {:ok, view, html} = live(conn, Routes.user_path(conn, :index))
    assert html =~ user.username
    Accounts.delete_user(user)
    refute render(view) =~ user.username
  end

  test "updated user will show updates on the view", %{conn: conn} do
    user = Fixtures.user_fixture()
    {:ok, view, html} = live(conn, Routes.user_path(conn, :index))
    assert html =~ user.username
    updated_username = "newusername"
    {:ok, _user} = Accounts.update_user(user, %{username: updated_username})
    html = render(view)
    assert html =~ updated_username
    refute html =~ user.username
  end

  test "can delete a user", %{conn: conn} do
    user = Fixtures.user_fixture()
    {:ok, view, html} = live(conn, Routes.user_path(conn, :index))
    assert html =~ user.username
    render_click(view, "delete-user", "#{user.id}")
    refute render(view) =~ user.username
  end

  test "can create user", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.user_path(conn, :index))
    assert html =~ ~s(<div class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" id="new-user">)
    assert render_click(view, "show-modal") =~ ~s(<div class="modal fade show" data-backdrop="static" tabindex="-1" role="dialog" id="new-user" aria-modal="true" style="display: block;">)
    attrs = %{"email" => "test@test.com", "password" => "testing123", "username" => "testuser"}
    render_change(view, "validate-user", %{"user" => attrs})
    render_click(view, "submit-user")
    assert render(view) =~ "testuser"
  end
end

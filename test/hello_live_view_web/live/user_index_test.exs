defmodule HelloLiveViewWeb.UserIndexTest do
  use HelloLiveViewWeb.LiveViewCase
  alias HelloLiveView.Fixtures

  test "created user will show up on the view", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.user_path(conn, :index))
    user = Fixtures.user_fixture()
    refute html =~ user.username

    assert render(view) =~
             ~s(<a href="#{Routes.live_path(conn, HelloLiveViewWeb.UserShow, user)}">#{user.username}</a>)
  end

  test "can create user", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.user_path(conn, :index))

    assert html =~
             ~s(<div class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" id="new-user">)

    assert render_click(view, "show-modal") =~
             ~s(<div class="modal fade show" data-backdrop="static" tabindex="-1" role="dialog" id="new-user" aria-modal="true" style="display: block;">)

    attrs = %{"email" => "test@test.com", "password" => "testing123", "username" => "testuser"}
    render_change(view, "validate-user", %{"user" => attrs})
    render_click(view, "submit-user")
    assert render(view) =~ "testuser"
  end
end

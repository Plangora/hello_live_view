defmodule HelloLiveViewWeb.UserNewTest do
  use HelloLiveViewWeb.LiveViewCase

  @view HelloLiveViewWeb.UserNew

  setup do:
          {:ok,
           valid_attrs: %{
             "email" => "test@test.com",
             "password" => "testing123",
             "username" => "testuser"
           }}

  test "created user will redirect to the index page", %{conn: conn, valid_attrs: attrs} do
    {:ok, view, _html} = live(conn, Routes.live_path(conn, @view))
    html = render_change(view, "validate-user", %{"user" => attrs})
    assert html =~ ~s(<button class="btn btn-primary" type="submit">Submit</button>)
    refute html =~ "can&apos;t be blank"

    users_path = Routes.user_path(conn, :index)

    assert_redirect(view, ^users_path, fn ->
      assert render_submit(view, "submit-user", %{"user" => attrs})
    end)
  end

  test "cannot create invalid user", %{conn: conn, valid_attrs: attrs} do
    {:ok, view, _html} = live(conn, Routes.live_path(conn, @view))
    invalid_attrs = %{attrs | "username" => nil}
    html = render_change(view, "validate-user", %{"user" => invalid_attrs})

    assert html =~
             ~s(<button class="btn btn-primary" type="submit" disabled="disabled">Submit</button>)

    assert html =~ "can&apos;t be blank"

    assert render_submit(view, "submit-user", %{"user" => invalid_attrs}) =~ "can&apos;t be blank"
  end
end

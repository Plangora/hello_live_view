defmodule HelloLiveViewWeb.UserEditTest do
  use HelloLiveViewWeb.LiveViewCase

  setup do
    valid_attrs = %{
      "email" => "test@test.com",
      "password" => "testing123",
      "username" => "updateduser"
    }

    {:ok, user} =
      HelloLiveView.Accounts.create_user(%{
        "email" => "test@test.com",
        "password" => "testing123",
        "username" => "username"
      })

    {:ok, valid_attrs: valid_attrs, user: user}
  end

  test "created user will redirect to the index page", %{
    conn: conn,
    valid_attrs: attrs,
    user: user
  } do
    {:ok, view, _html} = live(conn, Routes.user_path(conn, :edit, user))
    html = render_change(view, "validate-user", %{"user" => attrs})
    assert html =~ ~s(<button class="btn btn-primary" type="submit">Submit</button>)
    refute html =~ "can&apos;t be blank"

    users_path = Routes.user_path(conn, :show, user)

    assert_redirect(view, ^users_path, fn ->
      assert render_submit(view, "submit-user", %{"user" => attrs})
    end)
  end

  test "cannot create invalid user", %{conn: conn, valid_attrs: attrs, user: user} do
    {:ok, view, _html} = live(conn, Routes.user_path(conn, :edit, user))
    invalid_attrs = %{attrs | "username" => nil}
    html = render_change(view, "validate-user", %{"user" => invalid_attrs})

    assert html =~
             ~s(<button class="btn btn-primary" type="submit" disabled="disabled">Submit</button>)

    assert html =~ "can&apos;t be blank"

    assert render_submit(view, "submit-user", %{"user" => invalid_attrs}) =~ "can&apos;t be blank"
  end

  test "can track if other users are also editing", %{conn: conn, user: user} do
    {:ok, view1, html} = live(conn, Routes.user_path(conn, :edit, user))
    assert html =~ "No other users are editing"
    {:ok, _view, html} = live(conn, Routes.user_path(conn, :edit, user))
    assert html =~ "1 other user(s) editing"
    assert render(view1) =~ "1 other user(s) editing"
  end
end

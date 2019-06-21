defmodule HelloLiveViewWeb.UserNewTest do
  use HelloLiveViewWeb.LiveViewCase

  @view HelloLiveViewWeb.UserNew

  setup do: {:ok, valid_attrs: %{"email" => "test@test.com", "password" => "testing123", "username" => "testuser"}}

  test "created user will redirect to the index page", %{valid_attrs: attrs} do
    {:ok, view, _html} = mount(@endpoint, @view, session: %{})
    html = render_change(view, "validate-user", %{"user" => attrs})
    assert html =~ ~s(<button type="submit">Submit</button>)
    refute html =~ "can&#39;t be blank"

    users_path = Routes.live_path(@endpoint, HelloLiveViewWeb.UserIndex)
    assert_redirect(view, ^users_path, fn -> 
      assert render_submit(view, "submit-user", %{"user" => attrs})
    end)
  end

  test "cannot create invalid user", %{valid_attrs: attrs} do
    {:ok, view, _html} = mount(@endpoint, @view, session: %{})
    invalid_attrs = %{attrs | "username" => nil}
    html = render_change(view, "validate-user", %{"user" => invalid_attrs})
    assert html =~ ~s(<button type="submit" disabled>Submit</button>)
    assert html =~ "can&#39;t be blank"

    assert render_submit(view, "submit-user", %{"user" => invalid_attrs}) =~ "can&#39;t be blank"
  end
end
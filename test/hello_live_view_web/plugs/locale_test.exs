defmodule HelloLiveViewWeb.LocaleTest do
  use HelloLiveViewWeb.ConnCase, async: true

  test "default locale will be using English", %{conn: conn} do
    conn =
      conn
      |> bypass_through(HelloLiveViewWeb.Router, :browser)
      |> get("/")

    assert get_session(conn, :locale) == "en"
    assert %{assigns: %{locale: "en"}} = conn
  end

  test "will accept locale if input from URL params", %{conn: conn} do
    conn =
      conn
      |> bypass_through(HelloLiveViewWeb.Router, :browser)
      |> get("/?locale=zh")

    assert get_session(conn, :locale) == "zh"
    assert %{assigns: %{locale: "zh"}} = conn
  end

  test "will not accept unknown locale", %{conn: conn} do
    conn =
      conn
      |> bypass_through(HelloLiveViewWeb.Router, :browser)
      |> get("/?locale=unknown")

    assert get_session(conn, :locale) == "en"
    assert %{assigns: %{locale: "en"}} = conn
  end
end

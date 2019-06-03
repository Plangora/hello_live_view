defmodule HelloLiveView.Fixtures do
  alias HelloLiveView.Accounts

  @valid_attrs %{
    email: "test@test.com",
    password: "some password",
    username: "some username"
  }
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

    %{user | password: nil}
  end
end

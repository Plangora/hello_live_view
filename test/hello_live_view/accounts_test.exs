defmodule HelloLiveView.AccountsTest do
  use HelloLiveView.DataCase, async: true

  alias HelloLiveView.{Accounts, Fixtures}
  alias Accounts.User

  describe "users" do
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} =
               Accounts.create_user(%{
                 email: "some.email@test.com",
                 password: "some password",
                 username: "some username"
               })

      assert user.email == "some.email@test.com"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{email: nil, password_digest: nil, username: nil})
    end
  end

  describe "created user" do
    setup do: {:ok, user: Fixtures.user_fixture()}

    test "list_users/0 returns all users", %{user: user} do
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id", %{user: user} do
      assert Accounts.get_user!(user.id) == user
    end

    test "update_user/2 with valid data updates the user", %{
      user: %{password_digest: digest} = user
    } do
      assert {:ok, %User{} = user} =
               Accounts.update_user(user, %{
                 email: "updated@test.com",
                 password: "updated password",
                 username: "some updated username"
               })

      assert user.email == "updated@test.com"
      refute user.password_digest == digest
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user(user, %{email: nil, password_digest: nil, username: nil})

      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user", %{user: user} do
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset", %{user: user} do
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "cannot create user with same username", %{user: %{username: username}} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{email: "other@test.com", username: username, password: "test pass"})
    end

    test "cannot create user with same email", %{user: %{email: email}} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{email: email, username: "other username", password: "test pass"})
    end
  end
end

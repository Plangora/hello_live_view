defmodule HelloLiveView.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :username, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    |> validate_length(:password, min: 8)
    |> put_password_hash()
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @doc false
  def register_changeset(user, attrs) do
    changeset(user, attrs)
    |> validate_required([:password])
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} when is_binary(pass) ->
        put_change(changeset, :password_digest, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end

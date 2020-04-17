defmodule HelloLiveView.Repo.Migrations.ChangeEmailUsernameType do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION citext", "DROP EXTENSION citext"
    alter table("users") do
      modify :email, :citext, from: :string, null: false
      modify :username, :citext, from: :strong, null: false
    end
  end
end

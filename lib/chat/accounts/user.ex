defmodule Chat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.Encryption

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string
    ## Virtual Fields ##
    field :password_hash, :string, virtual: true
    field :password_confirmation, :string, virtual: true


    timestamps()
  end

  @required_fields ~w(email username password)
  @optinal_fields ~w()

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> downcase_email
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)

    if password do
      encrypt_password = Encryption.hash_password(password)
      put_change(changeset, :password, encrypt_password)
    else
      changeset
    end


  end

  defp downcase_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end
end

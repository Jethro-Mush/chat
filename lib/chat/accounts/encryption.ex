defmodule Chat.Accounts.Encryption do
    alias Comeonin.Pbkdf2

    def hash_password(password), do: Pbkdf2.hashpwsalt(password)
    def validate_password(password, hash), do: Pbkdf2.checkpw(password, hash)
end

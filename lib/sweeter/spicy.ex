defmodule Sweeter.Spicy do

  def get_new_user_address_fake(_email, _mnemonic) do
    {:ok, address: "cosmos172czkdwsdefzzrxlsu4epkzx2ujj0jz3h8q8jm", mnemonic: "damne"}
  end

  def get_new_user_address(email, mnemonic) do
    IO.puts "in get new user address"
    url = buildurlRegister(email, mnemonic)

    IO.puts url
    IO.puts "after url"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode!(body) do
          %{"address" => address, "key" => key, "mnemonic" => mnemonic} ->
            {:ok, address: address, key: key, mnemonic: mnemonic}
          e ->
            IO.puts "e"
            IO.inspect e
            {:error}
        end
      {:ok, %HTTPoison.Response{status_code: 500, body: _body}} ->
        {:error}
      {:error, %HTTPoison.Error{} = error} ->
        IO.puts "error"
        IO.inspect error
        {:error}
    end
  end

  def get_tokes_by_address(address) do
    api_service = fetchSpicy1317()
    url = "#{api_service}/cosmos/bank/v1beta1/balances/#{address}"
    # headers = [{"Content-type", "application/json"}, {"accept", "application/json"}]

    IO.puts url
    IO.puts "in this get tokens by address"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode!(body) do
          %{"balances" => [%{"amount" => amount}]} ->
            IO.puts amount
            IO.puts 'after amount'
            {:ok, balance: amount}

          %{"balances" => []} ->
            {:ok, balance: 0}

          e ->
            IO.puts "e"
            IO.inspect e
            {:error}
        end
      {:ok, %HTTPoison.Response{status_code: 400, body: _body}} ->
        {:ok, balance: 0}
      {:error, %HTTPoison.Error{} = error} ->
        IO.puts "error"
        IO.inspect error
        {:error}
    end
  end

  def add_spicy_token(address, value) do

    IO.puts "in add token"
    headers = [
      {"accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    url = buildurlSendToken(address, "cosmos1ut70cd0krgtr4pxjvz5jyc2jnh7788gyl8p7mc", value)

    IO.puts url

    response = HTTPoison.get!(url, headers)

    Poison.decode!(response.body)
  end

  def take_spicy_token(address) do

    IO.puts "in take token"
    headers = [
      {"accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    url = buildurlSendToken("cosmos1ut70cd0krgtr4pxjvz5jyc2jnh7788gyl8p7mc", address, "1token")

    IO.puts url

    HTTPoison.get!(url, headers)
  end

  defp buildurlRegister(email, mnemonic) do
    spicy_service = fetchSpicy5555()
    if mnemonic == nil or mnemonic == "" do
      URI.encode("#{spicy_service}/?name=#{email}")
    else
      URI.encode("#{spicy_service}/?name=#{email}&mnemonic=#{mnemonic}")
    end
  end

  defp buildurlSendToken(to_account, from_account, amount) do
    spicy_service = fetchSpicy5555()
    URI.encode("#{spicy_service}/send_tokens?to_account=#{to_account}&from_account=#{from_account}&amount=#{amount}")
  end

  defp fetchSpicy1317() do
    Application.get_env(:sweeter, :api1317)
  end

  defp fetchSpicy4500() do
    Application.get_env(:sweeter, :faucet4500)
  end

  defp fetchSpicy5555() do
    Application.get_env(:sweeter, :assigner5555)
  end
end

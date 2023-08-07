defmodule Sweeter.Spicy do

  def get_new_user_address_fake(_email, _mnemonic) do
    {:ok, address: "cosmos172czkdwsdefzzrxlsu4epkzx2ujj0jz3h8q8jm", mnemonic: "damne"}
  end

  def get_new_user_address(email, mnemonic) do
    IO.puts "in get new user address"
    url = buildurl(email, mnemonic)

    IO.puts url
    IO.puts "after url"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode!(body) do
          %{"address" => address, "key" => _key, "mnemonic" => mnemonic} ->
            {:ok, address: address, mnemonic: mnemonic}
          e ->
            IO.puts "e"
            IO.inspect e
            {:error}
        end
      {:error, %HTTPoison.Error{} = error} ->
        IO.puts "error"
        IO.inspect error
        {:error}
    end
  end

  def get_tokes_by_address(address) do
    api_service = fetchSpicy1317()
    url = "#{api_service}/cosmos/bank/v1beta1/balances/#{address}"
    headers = [{"Content-type", "application/json"}, {"accept", "application/json"}]

    IO.puts url
    IO.puts "in this get tokens by address"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode!(body) do
          %{"balances" => [%{"amount" => amount}]} ->
            {:ok, balance: amount}
          e ->
            IO.puts "e"
            IO.inspect e
            {:error}
        end
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

    body = %{
      "address" => address,
      "coins" => [value]
    }
    faucet = fetchSpicy4500()

    response = HTTPoison.post!(faucet, Poison.encode!(body), headers)

    # Access the response status code, headers, and body
    # status_code = response.status_code
    # response_headers = response.headers
    # response_body =
      IO.inspect response
    Poison.decode!(response.body)
  end

  defp buildurl(email, mnemonic) do
    spicy_service = fetchSpicy5555()
    if mnemonic == nil or mnemonic == "" do
      URI.encode("#{spicy_service}/?name=#{email}")
    else
      URI.encode("#{spicy_service}/?name=#{email}&mnemonic=#{mnemonic}")
    end
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

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

  def take_spicy_token(address, value) do
    IO.puts "in take token"
    headers = [
      {"accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    # Assuming 'from_address' is the address from which you're sending tokens
    # and 'your_password' is the password for the 'from_address' account.
    from_address = "cosmos_sender_address"
    your_password = "your_password"

    body = %{
      "base_req" => %{
        "from" => from_address,
        "chain_id" => "your_chain_id",
        "gas" => "auto",
        "gas_adjustment" => "1.2",
        "gas_prices" => [%{"denom" => "token", "amount" => "0.025"}]
      },
      "amount" => [%{"denom" => "token", "amount" => value}],
      "from_address" => from_address,
      "to_address" => address
    }

    cosmos1317 = fetchSpicy1317()
    api_service = fetchSpicy1317()
    url = "#{api_service}/cosmos/bank/v1beta1/balances/#{address}"
    # Replace 'localhost:1317' with the address of your Cosmos full node
    url = "#{cosmos1317}/cosmos/bank/accounts/#{from_address}/transfers"

    response = HTTPoison.post!(url, Poison.encode!(body), headers)

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

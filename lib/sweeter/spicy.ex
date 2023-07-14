defmodule Sweeter.Spicy do

  def get_new_user_address_fake(email, mnemonic) do
    {:ok, address: "someaddress", mnemonic: "damne"}
  end

  def get_new_user_address(email, mnemonic) do
    IO.puts "in get new user address"
    url = buildurl(email, mnemonic)
    IO.inspect url
    headers = []

    try do
      {_status, response} =
        HTTPoison.get(
          url,
          '',
          headers
        )

        IO.inspect response
        %{"address" => address, "key" => _key, "mnemonic" => mnemonic} = Poison.decode!(response.body)
        IO.inspect address
        IO.inspect "hello"
        # creatable = Map.merge(user_params, %{"address" => address})
        # IO.inspect creatable
        {:ok, address: address, mnemonic: mnemonic}
      rescue
      e in HTTPoison.Error ->
        IO.inspect(e)
        {:error}
    end
  end

  def get_cosmos_by_address(address) do
    url = "http://cosmos:1317/cosmos/auth/v1beta1/accounts/#{address}"
    headers = [{"Content-type", "application/json"}, {"accept", "application/json"}]

    IO.puts "in this get cosmos by address"
    try do
      {status, response} =
        HTTPoison.get(
          url,
          '',
          headers
        )
        IO.inspect status
        IO.inspect response
    rescue
      e in HTTPoison.Error ->
        IO.inspect(e)
    end
  end

  def add_spicy_token(address, value) do
    headers = [
      {"accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    body = %{
      "address" => address,
      "coins" => [value]
    }

    response = HTTPoison.post!("http://cosmos:4500/", Poison.encode!(body), headers)

    # Access the response status code, headers, and body
    status_code = response.status_code
    response_headers = response.headers
    response_body = Poison.decode!(response.body)

    IO.inspect(status_code)
    IO.inspect(response_headers)
    IO.inspect(response_body)
  end

  defp buildurl(email, mnemonic) do
    if mnemonic == nil or mnemonic == "" do
      URI.encode("http://cosmos:5555/?name=#{email}")
    else
      URI.encode("http://cosmos:5555/?name=#{email}&mnemonic=#{mnemonic}")
    end
  end
end

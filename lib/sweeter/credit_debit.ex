defmodule Sweeter.CreditDebit do
  alias Sweeter.UserCache

  def increment_api(address) do
    case get_cache_from_address(address) do
      %Sweeter.UserCache{
          address: address,
          reaction_count: reaction_count,
          api_count: api_count} ->
        new_value = api_count + 1
        address_write(address, reaction_count, new_value)
        modulus_100(address, new_value)
        new_value
      nil ->
        address_write(address)
        modulus_100(address, 0)
        0
    end
  end

  def increment_interaction(address) do
    case get_cache_from_address(address) do
      %Sweeter.UserCache{
          address: address,
          reaction_count: reaction_count,
          api_count: api_count} ->
        new_value = reaction_count + 1
        address_write(address, new_value, api_count)
        modulus_10(address, new_value)
        new_value
      nil ->
        address_write(address)
        modulus_10(address, 0)
        0
    end
  end

  defp get_cache_from_address(address) do
    Memento.transaction! fn ->
      Memento.Query.read(UserCache, address)
    end
  end

  defp address_write(address) do
    Memento.transaction! fn ->
      Memento.Query.write(%UserCache{address: address, reaction_count: 0, api_count: 0})
    end
  end

  defp address_write(address, reaction_count, api_count) do
    Memento.transaction! fn ->
      Memento.Query.write(%UserCache{address: address, reaction_count: reaction_count, api_count: api_count})
    end
  end

  defp modulus_10(address, value) do
    if rem(value, 10) == 0 do
      Sweeter.Spicy.add_spicy_token(address, "1token")
    end
  end

  defp modulus_100(address, value) do
    if rem(value, 100) == 0 do
      Sweeter.Spicy.add_spicy_token(address, "1token")
    end
  end
end

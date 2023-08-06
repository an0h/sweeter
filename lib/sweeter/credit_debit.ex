defmodule Sweeter.CreditDebit do

  def increment_api(address) do
    case get_cache_from_address(address) do
      {:atomic, [%{
          address: address,
          reaction_count: reaction_count,
          api_count: api_count}]} ->
        new_value = api_count + 1
        address_write(address, reaction_count, new_value)
        modulus_100(address, new_value)
        new_value
      {:aborted, {:no_exists, User}} ->
        :mnesia.create_table(User, [:address, :reaction_count, :api_count])
      nil ->
        address_write(address)
        modulus_100(address, 0)
        0
    end
  end

  def increment_interaction(address) do
    case get_cache_from_address(address) do
      {:atomic, [%{
          address: address,
          reaction_count: reaction_count,
          api_count: api_count}]} ->
        new_value = reaction_count + 1
        address_write(address, new_value, api_count)
        modulus_10(address, new_value)
        new_value
      {:aborted, {:no_exists, User}} ->
        :mnesia.create_table(User, [:address, :reaction_count, :api_count])
      nil ->
        address_write(address)
        modulus_10(address, 0)
        0
    end
  end

  def u_get_a_token(address) do
    Sweeter.Spicy.add_spicy_token(address, "1token")
  end

  defp get_cache_from_address(address) do
    data_to_read = fn ->
      :mnesia.read({User, address})
    end
    :mnesia.transaction(data_to_read)
  end

  defp address_write(address) do
    data_to_write = fn ->
      :mnesia.write({User, address, 0, 0})
    end
    :mnesia.transaction(data_to_write)
  end

  defp address_write(address, reaction_count, api_count) do
    data_to_write = fn ->
      :mnesia.write({User, address, reaction_count, api_count})
    end
    :mnesia.transaction(data_to_write)
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

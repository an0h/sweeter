defmodule Sweeter.CreditDebit do

  def increment_interaction(address) do
    case :ets.lookup(:user_interactions, address) do
      [{^address, value}] ->
        new_value = value + 1
        :ets.insert(:user_interactions, {address, new_value})
        modulus_10(address, new_value)
        new_value

      [] ->
        :ets.insert(:user_interactions, {address, 0})
        modulus_10(address, 0)
        0
    end
  end

  defp modulus_10(address, value) do
    if rem(value, 10) == 0 do
      Sweeter.Spicy.add_spicy_token(address, "1token")
    end
  end

  def increment_api(address) do
    case :ets.lookup(:api_activities, address) do
      [{^address, value}] ->
        new_value = value + 1
        :ets.insert(:api_activities, {address, new_value})
        modulus_100(address, new_value)
        new_value

      [] ->
        :ets.insert(:api_activities, {address, 0})
        modulus_100(address, 0)
        0
    end
  end

  defp modulus_100(address, value) do
    if rem(value, 100) == 0 do
      Sweeter.Spicy.add_spicy_token(address, "1token")
    end
  end
end

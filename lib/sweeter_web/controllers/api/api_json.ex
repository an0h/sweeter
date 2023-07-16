defmodule SweeterWeb.API.V1.APIJSON do
  alias Sweeter.Content.Item

  def items(%{items: items}) do
    %{data: for(item <- items, do: itemize(item))}
  end

  def item(%{item: item}) do
    %{item: itemize(item)}
  end

  defp itemize(%Item{} = item) do
    %{
      title: item.title,
      body: item.body,
      source: item.source
    }
  end
end

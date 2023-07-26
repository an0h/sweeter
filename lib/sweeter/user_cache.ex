defmodule Sweeter.UserCache do
  use Memento.Table, attributes: [:address, :reaction_count, :api_count]
end

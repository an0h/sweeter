defmodule SweeterWeb.Pow.ControllerCallbacks do
  alias Pow.Extension.Phoenix.ControllerCallbacks

  # def before_respond(Pow.Phoenix.SessionController, :create, {:ok, user, conn}, config) do
  #   IO.puts "before respond"
  #   IO.inspect conn
  #   {:ok, user, conn}
  # end
  # def before_respond(Pow.Phoenix.SessionController, :create, {:ok, conn}, config) do
  #   ControllerCallbacks.before_respond(Pow.Phoenix.SessionController, :create, {:ok, conn}, config)
  # end
  # def before_respond(Pow.Phoenix.SessionController, :delete, {:ok, conn}, config) do
  #   ControllerCallbacks.before_respond(... remove_info_from_conn...)
  # end

  defdelegate before_respond(controller, action, results, config), to:  ControllerCallbacks

  defdelegate before_process(controller, action, results, config), to: ControllerCallbacks
end

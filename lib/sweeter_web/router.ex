defmodule SweeterWeb.Router do
  alias SweeterWeb.ItemController
  use SweeterWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SweeterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Pow.Plug.Session, otp_app: :sweeter
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug SweeterWeb.APIAuthPlug, otp_app: :sweeter
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: SweeterWeb.APIAuthErrorHandler
  end

  scope "/" do
    pipe_through :browser

    get "/mnemonic", SweeterWeb.SpicyController, :get_mnemonic
    post "/show_mnemonic", SweeterWeb.SpicyController, :show_mnemonic
    resources "/items", SweeterWeb.ItemController

    pow_routes()
    pow_extension_routes()
  end

  scope "/", SweeterWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api/v1", SweeterWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", SweeterWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    get "/get_items", APIController, :search
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sweeter, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SweeterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

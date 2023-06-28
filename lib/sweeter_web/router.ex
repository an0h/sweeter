defmodule SweeterWeb.Router do
  use SweeterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SweeterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug SweeterWeb.APIaccess
  end

  pipeline :maybe_browser_auth do
    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource)
  end

  pipeline :ensure_authed_access do
    plug(Guardian.Plug.EnsureAuthenticated, %{"typ" => "access", handler: Sweeter.HttpErrorHandler})
  end

  scope "/", SweeterWeb do
    pipe_through :browser

    get "/", PageController, :home

    get "/login", UserController, :login
    post "/create_session", UserController, :create_session

    resources "/items", ItemController

    post "/users/subscribe/:id", UserController, :subscribe
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  scope "/", SweeterWeb do
    pipe_through :api

    get "/api", FeedController, :index
    get "/api/item/list", FeedController, :api_item_list
    post "/api/item/create", FeedController, :api_item_create

    resources "/feeds", FeedController, except: [:new, :edit]
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

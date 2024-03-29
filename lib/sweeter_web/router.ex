defmodule SweeterWeb.Router do
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
    plug SweeterWeb.LoggedInIdPlug
    plug Pow.Plug.Session, otp_app: :sweeter
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug SweeterWeb.APIAuthPlug, otp_app: :sweeter
    plug OpenApiSpex.Plug.PutApiSpec, module: SweeterWeb.API.V1.ApiSpec
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: SweeterWeb.AuthErrorHandler
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: SweeterWeb.APIAuthErrorHandler
  end

  pipeline :moderators_only do
    plug SweeterWeb.ModeratorPlug
  end

  pipeline :css_customizer do
    plug SweeterWeb.CssCustomizerPlug
  end

  scope "/", SweeterWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about
    get "/about_api", PageController, :about_api
    get "/about_anon", PageController, :about_anon
    get "/about_tech", PageController, :about_tech
    get "/energy", PageController, :energy
    get "/plans", PageController, :plans
    get "/privacy", PageController, :privacy

    get "/items/page/:page", ItemController, :paginating
    resources "/items", ItemController
    resources "/searches", SearchController
    resources "/streets", StreetController

    get "/search", SearchController, :search_by_tag
    get "/search/tag/:tag_slug", SearchController, :search_by_tag
    get "/search/text/", SearchController, :search_by_term

    get "/tag/popular_tags", SearchController, :popular_tags

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/" do
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/v1/openapi"

    pow_routes()
    pow_extension_routes()
  end

  scope "/" do
    pipe_through [:browser, :protected]

    get "/subscriptions", SweeterWeb.SearchController, :subser_feed

    get "/profile/subscribe/:id", SweeterWeb.ProfileController, :subscribe
    get "/profile/unsubscribe/:id", SweeterWeb.ProfileController, :unsubscribe
    get "/profile/block/:id", SweeterWeb.ProfileController, :block
    get "/profile/unblock/:id", SweeterWeb.ProfileController, :unblock
    get "/profile/censor/:id", SweeterWeb.ProfileController, :censor
    get "/profile/edit/:id", SweeterWeb.ProfileController, :edit_profile
    put "/profile/update", SweeterWeb.ProfileController, :update_profile

    get "/mnemonic", SweeterWeb.SpicyController, :get_mnemonic
    post "/show_mnemonic", SweeterWeb.SpicyController, :show_mnemonic

    resources "/moderations", SweeterWeb.ModerationController,  only: [:index, :show, :create, :new]
  end

  scope "/" do
    pipe_through [:browser, :protected, :moderators_only]
    get "/about_mod", SweeterWeb.PageController, :about_mod

    get "/item/feature/:id", SweeterWeb.ItemController, :feature_item
    get "/item/unfeature/:id", SweeterWeb.ItemController, :unfeature_item

    get "/moderate_item/:id", SweeterWeb.ItemController, :moderate_item
    put "/moderate_item/:id", SweeterWeb.ItemController, :moderator_item_update

    get "/moderator/list_tags", SweeterWeb.ModerationController, :list_tags
    get "/moderator/create_tag", SweeterWeb.ModerationController, :new_tag
    post "/moderator/create_tag", SweeterWeb.ModerationController, :create_tag

    get "/moderator/create_style", SweeterWeb.ModerationController, :new_css
    post "/moderator/create_css", SweeterWeb.ModerationController, :create_css

    get "/moderator/pending", SweeterWeb.ModerationController, :list_pending_moderations
  end

  scope "/" do
    pipe_through [:browser, :protected, :css_customizer]

    get "/:handle", SweeterWeb.ProfileController, :handle_profile

    get "/profile/:id", SweeterWeb.ProfileController, :show_profile
  end

  scope "/api/v1", as: :api_v1 do
    pipe_through :api

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api/v1", SweeterWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1", SweeterWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    get "/get_tag_list", APIController, :api_tag_slug_list
    get "/get_restricted_tag_list", APIController, :api_restricted_tag_slug_list
    get "/get_items", APIController, :search
    post "/create_item", APIController, :api_item_create
  end

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

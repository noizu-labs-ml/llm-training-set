defmodule SyntheticManagerWeb.Router do
  use SyntheticManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SyntheticManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SyntheticManagerWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/features", FeatureLive.Index, :index
    live "/features/new", FeatureLive.Index, :new
    live "/features/:id/edit", FeatureLive.Index, :edit
    live "/features/:id", FeatureLive.Show, :show
    live "/features/:id/show/edit", FeatureLive.Show, :edit

    live "/synthetics/interactive", SyntheticLive.Interactive, :index
    live "/synthetics/upload", SyntheticLive.Upload, :index
    live "/synthetics/upload/new", SyntheticLive.Upload, :new
    live "/synthetics/upload/:id/edit", SyntheticLive.Upload, :edit

    live "/synthetics", SyntheticLive.Index, :index
    live "/synthetics/new", SyntheticLive.Index, :new
    live "/synthetics/:id/edit", SyntheticLive.Index, :edit
    live "/synthetics/:id", SyntheticLive.Show, :show
    live "/synthetics/:id/show/edit", SyntheticLive.Show, :edit


  end

  # Other scopes may use custom stacks.
  # scope "/api", SyntheticManagerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:synthetic_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SyntheticManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

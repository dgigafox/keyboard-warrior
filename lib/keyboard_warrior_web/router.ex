defmodule KeyboardWarriorWeb.Router do
  use KeyboardWarriorWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", KeyboardWarriorWeb do
    # Use the default browser stack
    pipe_through(:browser)

    live("/", Game)
  end

  # Other scopes may use custom stacks.
  # scope "/api", KeyboardWarriorWeb do
  #   pipe_through :api
  # end
end

defmodule WorkoutDemo.Router do
  use WorkoutDemo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WorkoutDemo do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/sessions", SessionController, only: [:create]

	# JSON REST Routes for Searching
    get "/search/users", LocationQueryController, :search_users_within_radius
    post "/search/users", LocationQueryController, :users_within_radius

  end
end

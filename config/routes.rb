Rails.application.routes.draw do
  resources :flags
  resources :commands

  # repositories
  post "/create_repository", to: "repositories#create_repository"
  get "/get_repository", to: "repositories#get_repository"
  post "/upload", to: "repositories#upload_project_to_repository"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

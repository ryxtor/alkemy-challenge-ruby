Rails.application.routes.draw do
  # Users routes
  post 'v1/user', to: 'v1/users#authenticate', as: 'authentication_user'
  post 'v1/user/add', to: 'v1/users#add', as: 'add_user_path'

  namespace :v1 do
    resources :characters, only: %i[index show create update destroy]
    resources :genres, only: %i[index show create update destroy]
    resources :movies, only: %i[index show create update destroy]
  end
end

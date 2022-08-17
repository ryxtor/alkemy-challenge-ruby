Rails.application.routes.draw do
  # Users routes
  post 'v1/user', to: 'users#authenticate', as: 'authentication_user'
  post 'v1/user/add', to: 'users#add', as: 'add_user_path'
end

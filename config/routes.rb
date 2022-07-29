Rails.application.routes.draw do
  namespace :admin do
    resources :posts

    root to: 'posts#index'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'posts#index'
end

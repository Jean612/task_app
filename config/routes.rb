Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "pages#home"
  get "/homepage", to: "pages#home"
  resources :tasks do
    collection do
      get :order_list
    end
  end
end

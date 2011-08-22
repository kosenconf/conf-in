ConfInProcon::Application.routes.draw do
  devise_for :users

  resources :users

	# root
	root to: "home#index"

	# for devise
	devise_for :users
	get "users", to: "users#show", as: :user_root

end

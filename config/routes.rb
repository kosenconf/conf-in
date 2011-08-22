ConfInProcon::Application.routes.draw do
  resources :users

	# root
	root to: "home#index"
	get "home/index"

	# for devise
	devise_for :users
	get "users", to: "users#show", as: :user_root

end

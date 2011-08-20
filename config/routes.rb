ConfInProcon::Application.routes.draw do
  get "sample/index"

	# root
	root to: "home#index"
	get "home/index"

	# for devise
	devise_for :users
	get "users", to: "users#show", as: :user_root

end

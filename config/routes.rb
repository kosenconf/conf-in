ConfInProcon::Application.routes.draw do

	# root
	root to: "home#index"
	get "home/index"

	# for devise
	devise_for :users
	get "users", to: "users#show", as: :user_root

	#match ':controller(/:action(/:id(.:format)))'
	resources :events do
		resources :entries do
			collection do
				get :xml
				post :confirm
				post :complete
				post :ticket
			end
		end
	end
	resources :users
end

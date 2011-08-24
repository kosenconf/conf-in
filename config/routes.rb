ConfInProcon::Application.routes.draw do

	# root
	root to: "home#index"
	
	#resources :users, only: [:index, :show, :update]
	# get "users/:id"の後に置かないこと
	
	
  resources :users do
    get :profile, on: :collection
  end
	# for devise
	devise_for :user, controllers: {registrations: "user/registrations"}
	#get "/users/profile", to: "users#profile"
	#get "users/:id", to: "users#show", as: :user_root

	
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
	

end

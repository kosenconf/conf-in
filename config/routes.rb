ConfInProcon::Application.routes.draw do
	# root
	root to: "home#index"
  
  # Userリソース
  resources :users, only: [ :show ]

	# deviseの設定
	devise_for :user
  
  # Eventリソース
	resources :events do
	  # Entryリソース
		resources :entries do
			collection do
				get :xml
				post :confirm
				post :complete
				post :ticket
			end
		end
	end
	
	get 'home/about', to: 'home#about'
end

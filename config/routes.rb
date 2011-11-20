ConfInProcon::Application.routes.draw do
	# root
	root to: "home#index"
  
  # Userリソース
  resources :users, only: [ :show ] do
    member do
			# Google Maps
      get :map # /users/:id/map
    end
  end

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
				get :qr_receive
				post :receive
			end
		end

		# mails
		resources :event_mails, only: [:index, :show, :new, :create] do
		  collection do
		    post :confirm
		  end
		end
    
    
		member do
			# Google Maps
			get :map # /events/:id/map
			get :admin
			get :resend_entry_mail
		end
	end
	
	get 'about', to: 'home#about'
	get 'help', to: 'help#index'
end

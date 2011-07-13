Liveplus::Application.routes.draw do
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match '/activate/:activation_code' => 'activations#create', :as => :activate

  resources :password_resets, :only => [ :new, :create, :edit, :update ]
  resource :user_session
  resources :users do

    collection do
      get 'resend_activation'
    end
  end
  root :to => "pages#index"
end

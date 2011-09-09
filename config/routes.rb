Tramampoline::Application.routes.draw do
  match '/' => 'home#index'
  match '/register' => 'attendees#new', :as => :register
  match '/accept_invite/:invite_code' => 'attendees#new', :as => :accept
  match '/guide' => 'home#guide', :as => :guide
  match '/sydney' => 'home#sydney', :as => :guide

  resources :attendees do
    collection do
      get :pending, :sold_out, :patience
    end

    member do
      get :confirmed, :cancelled
    end
  end

  resources :ipns, :only => :create

  resources :subscribers
  resources :waiting_list, :controller => 'waiting_lists'

  match '/:controller(/:action(/:id))'
end

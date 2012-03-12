Tramampoline::Application.routes.draw do
  match '/' => 'home#index'
  match '/guide' => 'home#guide', :as => :guide
  match '/sydney' => 'home#sydney', :as => :guide

  resources :events do
    match '/register' => 'attendees#new', :as => :register
    match '/accept_invite/:invite_code' => 'attendees#new', :as => :accept

    resources :attendees do
      collection do
        get :pending, :sold_out, :patience
      end

      member do
        get :confirmed, :cancelled
      end
    end

    resources :waiting_list, :controller => 'waiting_lists'
  end

  resources :ipns, :only => :create

  resources :subscribers

  match '/:controller(/:action(/:id))'
end

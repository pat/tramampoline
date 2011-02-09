Tramampoline::Application.routes.draw do
  match '/' => 'home#index'
  match '/register' => 'attendees#new', :as => :register
  match '/accept_invite/:invite_code' => 'attendees#new', :as => :accept
  match '/step_forward/:waiting_code' => 'attendees#new', :as => :step_forward
  match '/guide' => 'home#guide', :as => :guide
  match '/sydney' => 'home#sydney', :as => :guide
  
  resources :attendees do
    collection do
      get :pending, :sold_out, :patience
    end
  end
  
  resources :subscribers
  resources :waiting_list, :controller => 'waiting_lists'
  
  match '/:controller(/:action(/:id))'
end

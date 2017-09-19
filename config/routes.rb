Tramampoline::Application.routes.draw do
  get '/' => 'home#index', :as => :home
  get '/guide' => 'home#guide', :as => :guide
  get '/sydney' => redirect("http://pozible.com/trampolinesydney")
  # match '/sydney' => 'home#sydney', :as => :guide
  get '/register' => redirect('/events/7-melbourne/register')
  get '/accept_invite/:code' => redirect("/events/7-melbourne/accept_invite/%{code}")

  resources :events do
    get '/register' => 'attendees#new', :as => :register
    get '/accept_invite/:invite_code' => 'attendees#new', :as => :accept

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
end

VacationShare::Application.routes.draw do
  root :to => "homes#index"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  resources :users
end

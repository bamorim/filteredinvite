FilteredInvite::Application.routes.draw do
  root to: "invite#index"

  post "/invite" => "invite#invite"

  match '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/facebook', as: :facebook_login
  get '/sign_out', to: "sessions#destroy", as: :sign_out
end

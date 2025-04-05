

Rails.application.routes.draw do
  # Root path
  root "sessions#new"

  # User sign up
  get "/signup", to: "users#new", as: "signup"
  post "/users", to: "users#create"
# update user
  resources :users, only: [:edit, :update]
  # Session (Login/Logout)
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  # Dashboard
  get "/dashboard", to: "dashboard#show", as: "dashboard"

  # Transactions
  get "/transactions", to: "transactions#index", as: :transactions

  # Friend Requests
  resources :friend_requests, only: [:create] do
    collection do
      get 'accept'
    end
  end

  # Friendships
  resources :friendships, only: [:new, :create]

  # Groups
  resources :groups, only: [:create, :show, :destroy] do
    member do
      get 'generate_invite_token'
      get 'invite', to: 'groups#invite', as: 'invite'
      
    end
  end
# Group add member
  resources :groups do
    member do
      post 'add_member'  # Define the route for adding a member
      post 'add_member_email', to: 'groups#add_member_email', as: 'add_member_email'
    end
  end
  
  # Group Memberships
  resources :group_memberships, only: [:create, :destroy]

  # Routes for generating and using group invite links
  get 'groups/invite/:token', to: 'groups#invite', as: 'group_invite'

  resources :groups do
    resources :expenses, only: [:new, :create,:edit, :update]
  end
#   Rails.application.routes.draw do
#     resources :groups do
#       # For viewing balances
#       get 'balances', to: 'balances#show', as: :balance
      
#       # For creating settlements
#       resources :settlements, only: [:create]
      
#       # Keep your existing expense routes
#       resources :expenses
#     end
#   end

# resources :groups do
#   resources :settlements, only: [:new, :create] do
#     collection do
#       get 'new/:payee_id', action: :new, as: :new_with_payee
#     end
#   end
# end
resources :groups do
  get 'balances', to: 'balances#show', as: :balance
  resources :settlements, only: [:new, :create] do
    collection do
      get 'new/:payee_id', action: :new, as: :new_with_payee
    end
  end
  resources :expenses
end
  
  # Health check for the app
  get "up", to: "rails/health#show", as: :rails_health_check
end

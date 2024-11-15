# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  mount ActionCable.server => "/cable"
  namespace :api do
    namespace :v1 do
      resources :authentication, only: [] do
        post "login", on: :collection
      end
      resources :positions
      resources :elections do
        get "show_election_candidates", on: :member
        resources :candidates, only: :create
        resources :votes, only: :create
      end
      resources :candidates, except: %i[index create]
      resources :voters, except: :create do
        post "register", on: :collection
      end
      resources :users, except: :create do
        post "register", on: :collection
      end
    end
  end
end

require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  root "home#index"

  mount Sidekiq::Web => '/sidekiq'

  resources :logs, only: %i[index]

  namespace :copart do
    resources :lots, only: %i[index create new destroy]
    resources :lots_processors, only: %i[index]
    resources :commands, only: %i[show]
  end

  namespace :api do
    namespace :copart do
      resources :credentials, only: %i(index)
      resource :receiver, only: %i(create)
    end
  end
end

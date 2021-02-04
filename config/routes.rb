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

  namespace :copart do
    resources :lots, only: %i[index create new destroy]
  end

  namespace :api do
    namespace :copart do
      resource :receiver, only: %i(create)
    end
  end
end

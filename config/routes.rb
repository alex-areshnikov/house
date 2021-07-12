require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root "home#index"

  mount Sidekiq::Web => '/sidekiq'

  resources :logs, only: %i[index]
  resources :expense_categories, only: %i[index new create destroy]
  resources :users, only: %i[index destroy]
  resources :quick_actions, param: :action_code, only: %i[show]

  resources :vehicles, only: %i[index], module: :vehicles do
    resources :expenses, except: %i[show index]

    resources :parent_folder, only: %i[] do
      resources :folders, only: %i[create]
    end

    resources :folders, only: %i[index show destroy] do
      resources :photos, only: %i[new create]
      resources :selected_photos, only: %i[create]
    end

    resources :quick_actions, param: :code, only: %i[] do
      namespace :folders do
        resource :selector, only: %i[show]
      end
    end
  end

  namespace :copart do
    resources :lots
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

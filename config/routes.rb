# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  resources :channels do
    member do
      patch :sort
    end
  end

  resource :browse, only: %i(create)

  namespace :channels do
    get ':id/today', to: 'today#show', as: 'today'
    get ':id/yesterday', to: 'yesterday#show', as: 'yesterday'
    get ':id/:year/:month/:day', to: 'days#show', as: 'day',
      year: /[1-9][0-9]{3}/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[12][0-9]|3[01]/
    get ':id/:year/:month', to: 'days#index', as: 'days',
      year: /[1-9][0-9]{3}/, month: /0[1-9]|1[0-2]/
    get ':id/:year', to: 'months#index', as: 'months', year: /[1-9][0-9]{3}/
  end

  namespace :messages do
    resource :search, only: %i(create show)
    resource :period, only: %i(create show)
  end

  resources :keywords, only: %i(index show)

  resources :users
  resources :user_sessions, only: %i(create)

  get 'login' => 'user_sessions#new', as: :login
  get 'logout' => 'user_sessions#destroy', as: :logout

  get 'settings' => 'settings#edit'
  put 'settings' => 'settings#update'
  patch 'settings' => 'settings#update'

  get 'admin' => 'admin#index', as: :admin

  namespace :admin do
    get 'status' => 'status#show', as: 'status'

    namespace :channels do
      get ':id/update-last-speech' => 'last_speech_updates#show',
        as: 'update_last_speech'
    end

    get 'channels/:id' => 'channels#show', as: 'channel'
    get 'channels' => 'channels#index', as: 'channels'

    resource :channel_order, only: %i(show)
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

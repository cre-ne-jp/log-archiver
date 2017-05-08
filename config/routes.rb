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
  end

  resources :users
  resources :user_sessions, only: %i(create)

  get 'login' => 'user_sessions#new', as: :login
  get 'logout' => 'user_sessions#destroy', as: :logout

  get 'settings' => 'settings#edit'
  put 'settings' => 'settings#update'
  patch 'settings' => 'settings#update'

  get 'admin' => 'admin#index', as: :admin

  namespace :admin do
    namespace :channels do
      get ':id/update-last-speech' => 'last_speech_updates#show',
        as: 'update_last_speech'
    end

    get 'channels/:id' => 'channels#show', as: 'channel'
    get 'channels' => 'channels#index', as: 'channels'

    resource :channel_order, only: %i(show)
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

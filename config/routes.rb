Rails.application.routes.draw do
  root 'welcome#index'

  resources :channels, only: %i(index)
  get '/channels/:identifier', to: 'channels#show', as: 'channel'

  namespace :channels do
    get ':identifier/:year/:month/:day', to: 'days#show', as: 'day',
      year: /[1-9][0-9]{3}/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[12][0-9]|3[01]/
    get ':identifier/:year/:month', to: 'days#index', as: 'days',
      year: /[1-9][0-9]{3}/, month: /0[1-9]|1[0-2]/
    get ':identifier/:year', to: 'months#index', as: 'months', year: /[1-9][0-9]{3}/
  end

  namespace :messages do
    resource :search, only: %i(create show)
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

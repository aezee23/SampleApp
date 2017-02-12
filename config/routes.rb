Rails.application.routes.draw do
get '/elders' => 'elders#index'
root "sessions#new"
get 'demo' => 'pages#index'
get 'last_sunday' => 'pages#last_sunday'
get 'last_sunday_charts' => 'pages#last_sunday_charts'
get 'time_series_charts' => 'pages#time_series_charts'
get 'monthly_average_charts' => 'pages#monthly_average_charts'
get 'visitation' => 'pages#visitation'
get 'visi_record' => 'pages#visi_record'
get 'data_sheet' => 'pages#data_sheet'
get 'retention' => 'pages#retention'
get 'show_nots' => 'pages#show'
get 'change_pwd' => 'users#change_pwd'
resources :church_groups
get 'login' => 'sessions#new'
post 'login' => 'sessions#create'
delete 'logout' => 'sessions#destroy'
get 'mobile-summary' => 'mobile_client#summary'
get "unauthorised" => 'mobile_client#unauthorised'
get 'users/:id/edit_my_profile' => 'users#edit_my_profile', as: :edit_my_profile

resources :users
resources :churches
resources :records
resources :password_resets,     only: [:new, :create, :edit, :update]
resources :datacards, only: [:index]
get 'datacard', to: 'datacards#show'
get 'datadetail', to: 'datacards#get_detail'
get 'change_password' => 'users#change_password'
patch 'change_password' => 'users#change_passwor'

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

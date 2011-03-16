Sudain::Application.routes.draw do

  match 'user/edit' => 'users#edit', :as => :edit

  match 'signup' => 'users#new', :as => :signup

  match 'logout' => 'sessions#destroy', :as => :logout

  match 'login' => 'sessions#new', :as => :login
  
  match 'sessions' => 'sessions#create'
  
  match 'users' => 'users#create'
  
  match 'sudas' => 'sudas#create'

  match 'following' => 'home#following'  
  
  match 'followers' => 'home#followers' 
  
  match 'people' => 'home#people', :as => :people
  
  match 'search' => 'home#search', :as => :search
  
  match 'settings' => 'settings#index', :as => :settings
  
  match 'all' => 'home#all', :as => :all
  
  match '/settings/update_settings' => 'settings#update_settings', :as => :update_settings
  
  match 'remove_friend/:username' => 'home#remove_friend'
  
  match '/more_suda/:page' => 'home#more_suda', :as => :more_suda
  
  match '/more_show_suda/:username/:page' => 'home#more_show_suda', :as => :more_show_suda
  
  match '/more_all_suda/:page' => 'home#more_all_suda', :as => :more_all_suda
  
  match '/more_search_suda/:page' => 'home#more_search_suda', :as => :more_search_suda
  
  match '/del_suda/:id' => 'home#del_suda', :as => :del_suda
  
  match 'rss' => 'home#rss', :as => :rss
  
  match 'rss/all' => 'home#all_rss', :as => :all_rss
  
  match 'rss/search/:q' => 'home#search_rss', :as => :search_rss
  
  match 'rss/:username' => 'home#user_rss', :as => :user_rss
  
  match 'twitter_callback' => 'sudas#twitter_callback', :as => :twitter_callback
  
  match ':username' => 'home#show', :as => :user_sudas
  
  match '/:username/toggle_follow' => 'home#toggle_follow', :as => :toggle_follow
  
  match '/:username/toggle_follow_via_ajax' => 'home#toggle_follow_via_ajax', :as => :toggle_follow_via_ajax
  
  resources :sessions

  resources :users
  
  resources :sudas

  root :to => "home#index"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

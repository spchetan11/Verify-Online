Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'landing_page#index'

  get    'search_page'                  => 'landing_page#search_page'
  get    'verification_status'          => 'landing_page#verification_status'
  post   'contact_create'               => 'landing_page#contact_create'

  get    'login'                        => 'sessions#new'
  get    'signup'                       => 'users#new'
  get    'login'                        => 'sessions#new'
  post   'login'                        => 'sessions#create'
  delete 'logout'                       => 'sessions#destroy'
  

  get    'apply'                        => 'student_verification#apply'
  post   'apply'                        => 'student_verification#apply'
  get    'status'                       => 'student_verification#status'

  get    'history'                      => 'student_verification#history'
  post   'proceed_to_pay'               => 'student_verification#proceed_to_pay'
  get    'payment_confirmation'         => 'student_verification#payment_confirmation'
  post   'instamojo_webhook'            => 'student_verification#instamojo_webhook'
  post   'add_verification'             => 'student_verification#add_verification'


  get    'view_verifications'           => 'college_verification#index'
  get    'completed_verifications'      => 'college_verification#completed'
  get    'final_report'                 => 'college_verification#report'
  get    'final_report_user'            => 'student_verification#report'
  get    'payment_details'              => 'college_verification#payment'
  put    'update'                       => 'college_verification#update'

  # resources :student_verification, :collection => { :update_multiple => :post}

  

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :users, except: [:show]
  resources :colleges
  resources :report_data, only: [:index, :update]

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
get 'application/raise_not_found'
get '*a' => redirect("application/raise_not_found")


end

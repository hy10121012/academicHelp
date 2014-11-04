AcdemicHelp::Application.routes.draw do

  get "administrator/verifyMaker"
  get "administrator/verifyTaker"
  get "home_page/verifyMaker"
  get "home_page/verifyTaker"
  get "request_files/do_upload_file"
  get "request_logs/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  class IsRequester
    def self.matches?(request)
      request.session[:user_type_id]==1
    end
  end

  class IsWriter
    def self.matches?(request)
      request.session[:user_type_id]==2
    end
  end


  root 'welcome#welcome'
  get 'login'=>'welcome#login'
  get 'logout'=>'welcome#logout'
  post 'login'=>'welcome#login_check'
  get 'register'=>'welcome#register'
  get 'find_country'=>'welcome#find_university_by_input'
  post 'register'=>'users#create'

  get 'home'=>'home#requester',constraints: IsRequester
  get 'home'=>'home#writer',constraints: IsWriter
  get 'my_request'=>'requests#maker_index' ,constraints: IsRequester
  get 'my_request'=>'requests#taker_index' ,constraints: IsWriter
  get 'request_market'=>'requests#market_index' ,constraints: IsWriter
  get 'request/:id/cancel'=>'requests#cancel'
  get 'request/:id/submit'=>'requests#submit'
  get 'request/:id/submitted'=>'requests#submitted'
  get 'request/:id/complaint'=>'requests#complaint'
  get 'request/:id/created'=>'requests#created'
  get 'request/has_paid'=>'requests#has_paid'
  get 'my_profile'=>'users#my_profile'
  post 'request/:id/complaint'=>'requests#do_complaint'
  post 'messages/send_message'=>'messages#send_message'
  get 'messages/:request_id'=>'messages#show'


  post 'messages/:request_id'=>'messages#send_message_in_list'

  post 'request/:id/submit'=>'requests#do_submit'
  post 'request_submit/progress'=>'requests#approve_process'
  post 'request/:id/close_down'=>'requests#close_down'
  post 'request/:id/complete_request'=>'requests#do_complete'
  post 'request/:id/cancel'=>'requests#do_maker_cancel' ,constraints: IsRequester
  post 'request/:id/cancel'=>'requests#taker_cancel' ,constraints: IsWriter
  post 'request/:id/take'=>'requests#do_take_request'
  post 'request/:id/approve'=>'requests#confirm_taker'
  get 'request/:id/payment'=>'requests#payment'
  get 'user_activate/'=>'welcome#activate_user'
  get 'resend_email'=>'welcome#resend_email'
  get 'forgot'=>'welcome#forgot'
  post 'resend_email'=>'welcome#do_resend_email'
  get 'validate_user'=>'users#validate_user'
  get 'register_success'=>'welcome#register_success'
  get '/forgot_password'=>'welcome#reset_pass'
  post '/reset_pass'=>'welcome#do_reset_pass'
 get 'reset_sucess'=>'welcome#reset_sucess'


  get 'get_university_by_country'=>'welcome#get_university_by_country_id'
  get 'get_writer_university_by_country'=>'welcome#get_writer_university_by_country_id'

  post 'request_files'=>'request_files#do_upload_file'
  post 'writer_validations'=>'users#do_validate_user'
  post 'request_files_delete'=>'request_files#do_delete_file'





  #admin
  get 'heyi_admin'=>'administrator#home'
  get 'heyi_admin/home'=>'administrator#home'
  get 'heyi_admin/verify_maker'=>'administrator#verify_maker'
  get 'heyi_admin/verify_taker'=>'administrator#verify_taker'
  patch 'heyi_admin/verify_maker'=>'administrator#do_verify_maker'














  resources :users
  resources :requests  do
    member do
      get :paid
      get :revoked
      post :ipn
    end
  end


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

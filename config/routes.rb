Rails.application.routes.draw do
  devise_for :admins
  
  get '/refresh/:day' => 'home#refresh'
  get'/out' =>'home#out'
  get '/like' => 'home#like'
  get '/newadmin' =>"home#newadmin"
  
  get '/keyboard' => 'chatbot#keyboard'
  post '/message' => 'chatbot#message'
  delete '/friend/:user_key' => 'chatbot#delfriend'
  delete '/chat_room/:user_key' => 'chatbot#chat_room'
  post '/friend' => 'chatbot#regfriend'
  
  namespace :data do
    resources :menulists, path_names: {edit: "/data/menulists/:id/edit/:page"}
    resources :rests
    resources :rmenus, except: [:index,:show,:edit,:new]
    resources :curates
  end
  
  get '/adpage/search/:id' =>"adpage#search"
  
  #엑셀 다운로드
  get '/download' =>"adpage#download"
  post '/excelinsert' =>'adpage#filesave'
  get '/oadpage/excel' => 'oadpage#excel'
  get '/get/excel' => 'oadpage#get_excel'
  post '/put/excel' => 'oadpage#put_excel'
  #일반화면
  get '/home/leftindex/:num' =>'ohome#leftindex'
  get '/home/rightindex/:id' =>'ohome#rightindex'
  get '/home/search' => 'ohome#search'
  get '/home/index' =>"ohome#index"
  
  scope module: :board do
    resources :posts, except: [:edit,:update]
    resources :comments, except: [:edit,:update,:show,:index,:new]
  end
  
  get '/board/login'=>'board#login'
  post '/board/login'=>'board#login'
  get '/board/block/:identity/:id' => 'board#block'
  
  get '/:id/:day' =>'home#index'
  root 'home#index'
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

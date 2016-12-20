Rails.application.routes.draw do
  devise_for :admins
  
  get '/refresh/:day' => 'home#refresh'
  get'/out' =>'home#out'#로그아웃
  get '/like' => 'home#like'#좋아요
  get '/newadmin' =>"home#newadmin"
  
  get '/keyboard' => 'chatbot#keyboard'
  post '/message' => 'chatbot#message'
  delete '/friend/:user_key' => 'chatbot#delfriend'
  delete '/chat_room/:user_key' => 'chatbot#chat_room'
  post '/friend' => 'chatbot#regfriend'
  
  namespace :data do
    resources :menulists, except: [:show], path_names: {edit: "/data/menulists/:id/edit/:page"}
  end
  
  get '/oadpage/image_del/:id' =>'oadpage#image_del'#이미지 삭제
  get '/oadpage/show_add' =>'oadpage#show_add' #이미지 등록 페이지
  get '/oadpage/show/:id' => 'oadpage#show_config'#이미지 보기
  post '/oadpage/image_add' => 'oadpage#image_add'#이미지 등록
  get '/oadpage/image_show' =>'oadpage#image_show' #등록 설정
  
  
  
  post '/oadpage/page/:id' =>'oadpage#page'#레스토랑 메뉴순서 저장
  get '/oadpage/rest_re/:id' => 'oadpage#rest_re' #식당수정 페이지
  get '/oadpage/rest_add' => 'oadpage#rest_add' #식당추가 페이지
  post '/oadpage/addrest' =>'oadpage#addrest'#식당추가 기능
  post '/oadpage/rewriterest/:id'=>"oadpage#rewriterest" #식당수정 기능
  get '/oadpage/delrest/:id' =>'oadpage#delrest'
  
  #식당메뉴추가
  get '/oadpage/addmenu_page/:id' =>'oadpage#addmenu_page'
  post '/oadpage/addmenu' =>'oadpage#addmenu'
  #식당메뉴삭제
  get '/oadpage/delmenu/:id' =>'oadpage#delmenu'
  #식당메뉴수정
  post '/oadpage/rewritemenu/:id' =>'oadpage#rewritemenu'
  post '/adpage/menulist/:info' => 'adpage#existmenu'
  
  
  #메인db페이지 두개
  get '/oadpage/dbmain' =>'oadpage#dbmain'
  
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

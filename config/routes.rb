Rails.application.routes.draw do
  


  devise_for :admins
  #get '/test' => "home#menutest"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  post '/oadpage/addrest' =>'oadpage#addrest'
  get '/oadpage/delrest/:id' =>'oadpage#delrest'
  
  #식당메뉴추가
  get '/oadpage/addmenu_page/:id' =>'oadpage#addmenu_page'
  post '/oadpage/addmenu' =>'oadpage#addmenu'
  #식당메뉴삭제
  get '/oadpage/delmenu/:id' =>'oadpage#delmenu'
  #식당메뉴수정
  post '/oadpage/rewriterest/:id'=>"oadpage#rewriterest"
  
  post '/adpage/menulist/:info' => 'adpage#existmenu'
  
  #메인db페이지 두개
  get '/adpage/dbmain/:id' =>'adpage#dbmain'
  get '/oadpage/dbmain' =>'oadpage#dbmain'
  
  
  get'/adpage/rewritemenu/:id/:info' =>'adpage#rewritemenu'
  
  
  post '/adpage/remenulist/:id/:info' => 'adpage#remenu'
  get '/adpage/delmenu/:id' =>'adpage#delmenu'
  
  
  #아이디 생성
  get '/home/newadmin' =>"home#newadmin"
  #엑셀 다운로드
  get '/download' =>"adpage#download"
  post '/excelinsert' =>'adpage#filesave'
  #일반화면
  get '/home/leftindex/:num/:dis/:lat/:lon' =>'ohome#leftindex', :constraints => { :lat => /.*/ ,:lon =>/.*/}
  get '/home/rightindex/:id/:num/:lat/:lon' =>'ohome#rightindex', :constraints => { :lat => /.*/ , :lon => /.*/}
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

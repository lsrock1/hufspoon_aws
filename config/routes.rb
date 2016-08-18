Rails.application.routes.draw do
  


  devise_for :admins
  
  get '/oadpage/image_del/:id' =>'oadpage#image_del'#이미지 삭제
  get '/oadpage/show_add' =>'oadpage#show_add' #이미지 등록 페이지
  get '/oadpage/show/:id' => 'oadpage#show_config'#이미지 보기
  post '/oadpage/image_add' => 'oadpage#image_add'#이미지 등록
  get '/oadpage/image_show' =>'oadpage#image_show' #등록 설정
  
  get'/adpage/out' =>'adpage#out'#로그아웃
  get '/like' => 'home#like'#좋아요
  
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
  get '/adpage/dbmain/:id' =>'adpage#dbmain'
  get '/oadpage/dbmain' =>'oadpage#dbmain'
  
  get '/adpage/newtrans/:info' => 'adpage#newtrans'
  get'/adpage/rewritemenu/:id/:info' =>'adpage#rewritemenu'
  post '/adpage/remenulist/:id/:info' => 'adpage#remenu'
  get '/adpage/delmenu/:id' =>'adpage#delmenu'
  get '/adpage/search/:id' =>"adpage#search"
  #아이디 생성
  get '/home/newadmin' =>"home#newadmin"
  #엑셀 다운로드
  get '/download' =>"adpage#download"
  post '/excelinsert' =>'adpage#filesave'
  #일반화면
  get '/home/leftindex/:num' =>'ohome#leftindex'
  get '/home/rightindex/:id' =>'ohome#rightindex'
  get '/home/search' => 'ohome#search'
  get '/home/index' =>"ohome#index"
  
  
  get '/board/out' =>'board#out'
  get '/board/cremove/:id' => 'board#cremove'
  post '/board/comment/:id' => 'board#comment'
  get '/board/remove/:id' => 'board#remove'
  get '/board/post/:id' =>'board#post'
  get '/board/write' => 'board#writepage'
  get '/board/hufslogin'=>'board#hufslogin'
  post '/board/hufslogin'=>'board#hufslogin'
  get '/board/seepost/:id' =>'board#seepost'
  post '/board/save' => 'board#save'
  
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

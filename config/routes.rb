Rails.application.routes.draw do
  devise_for :admins
  
  get '/refresh/:day' => 'systems#refresh'
  get'/out' =>'systems#out'
  get '/block/:identity/:id' => 'systems#block'
  get '/newadmin' =>"home#newadmin"
  
  get '/keyboard' => 'chatbot#keyboard'
  post '/message' => 'chatbot#message'
  delete '/friend/:user_key' => 'chatbot#delfriend'
  delete '/chat_room/:user_key' => 'chatbot#chat_room'
  post '/friend' => 'chatbot#regfriend'
  
  namespace :data do
    resources :menulists, path_names: {edit: "/edit/:page"} do
      get :search, on: :collection
    end
    resources :rests
    resources :rmenus, except: [:index,:show,:edit,:new]
    resources :curates
  end

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
  
  get '/like' => 'home#like'
  get '/:id/:day' =>'home#index'
  root 'home#index'
end

Rails.application.routes.draw do
  devise_for :admins
  
  get '/refresh/:day' => 'systems#refresh'
  get'/out' =>'systems#out'
  get '/block/:identity/:id' => 'systems#block'
  
  get '/keyboard' => 'chatbot#keyboard'
  post '/message' => 'chatbot#message'
  delete '/friend/:user_key' => 'chatbot#delfriend'
  delete '/chat_room/:user_key' => 'chatbot#chat_room'
  post '/friend' => 'chatbot#regfriend'
  
  namespace :data do
    resources :menulists, path_names: {edit: "/edit/:page"} do
      get :search, on: :collection
      get :top, on: :collection
      get :guide, on: :collection
    end
    resources :rests do
      delete '/picture/:number', on: :member, action: :destroy
    end
    resources :rmenus, except: [:index, :show, :edit, :new]
    resources :curates
    resources :diets,except: [:destroy, :show, :new], path_names: {edit: "/edit/:name"}
  end
  
  get '/rests/search' => 'ohome#search'
  get '/rests' => 'ohome#index'
  get '/rests/:id' => 'ohome#show'
  
  scope module: :board do
    resources :posts, except: [:edit,:update]
    resources :comments, except: [:edit,:update,:show,:index,:new]
  end
  
  get '/like' => 'home#like'
  get '/:id/:day' =>'home#index'
  root 'home#index'
end

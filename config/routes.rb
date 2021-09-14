Rails.application.routes.draw do
  # get 'users/new' as: 'signup'

  root 'static_pages#home'
  
  # get 'static_pages/home'

  # get 'static_pages/help'
  get '/help', to: 'static_pages#help'

  # get 'static_pages/about'
  get '/about' , to: 'static_pages#about'

  # get 'static_pages/contact'
  get '/contact', to: 'static_pages#contact'

  # signupで書き換え
  get '/signup', to: 'users#new'

  # users/1みたいなgetリクエストを実現する手段
  resources :users

end

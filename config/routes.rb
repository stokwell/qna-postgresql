Rails.application.routes.draw do
  get 'dashboards' => 'dashboards#index'

  resources :courses, shallow: true do 
    resources :seminars do 
       resources :questions      
    end
  end

  root to: 'courses#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post '/users/auth/proceed_with_email', to: 'omniauth_callbacks#with_email'
  end

  concern :votable do
    member do 
      post :upvote
      post :downvote
      post :cancel
    end
  end

  concern :commentable do 
     resources :comments
  end

  resources :questions, concerns: [:votable, :commentable] do

    resources :answers, concerns: [:votable, :commentable], shallow: true do 
      patch :best, on: :member
      resources :comments
    end

  end
  
  

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'

end

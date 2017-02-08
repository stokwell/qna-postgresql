Rails.application.routes.draw do
  get 'dashboards' => 'dashboards#index'

  resources :courses, shallow: true do 
    resources :seminars do 
       resources :questions      
    end
  end

  root to: 'courses#index'

  devise_for :users

  concern :votable do
    member do 
      post :upvote
      post :downvote
      post :cancel
    end
  end

  resources :questions, concerns: :votable do

    resources :answers, concerns: :votable, shallow: true do 
      patch :best, on: :member
      resources :comments
    end

  end
  
  

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'

end

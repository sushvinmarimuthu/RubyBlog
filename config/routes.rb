Rails.application.routes.draw do
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :tags

  root 'topics#index'
  resources :topics do
    resources :posts do
      post 'user_post_read_status', on: :member
      resources :comments, only: [:create, :destroy, :edit]
      resources :ratings
      resources :user_comment_rating
    end
  end
  resources :posts do
    post 'user_post_read_status', on: :member
    resources :user_comment_rating
  end
end

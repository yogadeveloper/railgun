Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      delete 'remove_vote'
    end
  end

  resources :authorizations, only: [:new, :create]
  get 'confirm_auth', controller: :authorizations
  get 'resend_confirmation_email', controller: :authorizations

  resources :questions, concerns: :votable do
    resources :comments, defaults: { commentable: 'questions' }

    resources :answers, concerns: :votable, shallow: true do
      resources :comments, defaults: { commentable: 'answers' }
      patch :mark_as_best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end

  root to: "questions#index"
end

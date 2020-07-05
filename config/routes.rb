Rails.application.routes.draw do
  resources :categories
  get 'keyword/index'
  get 'hash_tag/index'
  resources :memos
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'memos#index'
  get 'find/keyword/:keyword', to: 'memos#index', as: :find_keyword
  get 'find/hashtag/:hashtag', to: 'memos#index', as: :find_hashtag
  get 'find/category/:category', to: 'memos#index', as: :find_category
  post 'upload', to: 'memos#upload'
end

# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: [] do
        collection do
          post :invite
        end
      end
      namespace :docs do
        get 'api_docs', to: 'api_docs#index'
      end
    end
  end
end


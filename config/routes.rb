Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1i, path: 'internal/v1', defaults: { format: 'json' } do
      resources :tickets, only: [] do
        collection do
          post :votes
        end
      end
    end
  end
end

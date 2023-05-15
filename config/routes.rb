Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :plays, only: [:index, :create, :destroy]
    end
  end
end

Rails.application.routes.draw do
  root "documents#index"
 
  devise_for :users

  resources :documents do
    member do
      delete :delete_file
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

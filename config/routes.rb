Rails.application.routes.draw do
  root "documents#index"
 
  devise_for :users

  concern :fileable do
    member do
      delete "files/:file_id", action: :delete_file, as: :delete_file
    end
  end

  resources :documents, concerns: :fileable
end

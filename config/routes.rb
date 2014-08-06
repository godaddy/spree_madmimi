Spree::Core::Engine.routes.draw do

  namespace :admin do
    resource :mad_mimi, only: [] do
      collection do
        get :edit
        put :update
      end
    end
  end

  get "/auth/:provider/callback", to: "admin/sessions#create"
  get "/auth/failure", to: "admin/sessions#failure"
  delete "/auth/clear", to: "admin/sessions#destroy", as: :disconnect_mad_mimi

end

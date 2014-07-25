Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  resources :orders do
    resources :moip_slip, only: [:create, :show]
  end
end

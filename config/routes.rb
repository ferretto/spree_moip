Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post '/moip/generate_token', :to => "moip_slip#generate_token"
  post '/moip/notification', :to => "moip_slip#notification"
end

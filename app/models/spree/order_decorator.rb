module Spree
  Order.class_eval do
    has_one :moip_token
  end
end

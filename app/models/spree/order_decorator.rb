module Spree
  Order.class_eval do
    has_many :moip_tokens
  end
end

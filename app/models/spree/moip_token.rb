module Spree
  class MoipToken < ActiveRecord::Base
    belongs_to :order
    validates_presence_of :token, :order, :amount
  end
end

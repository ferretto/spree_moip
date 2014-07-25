module Spree
  class MoipSlip < ActiveRecord::Base
    has_one :payment, :as => :source
    belongs_to :order
  end
end

class AddAmountToSpreeMoipTokens < ActiveRecord::Migration
  def change
    add_column :spree_moip_tokens, :amount, :decimal, :precision => 10, :scale => 2
  end
end

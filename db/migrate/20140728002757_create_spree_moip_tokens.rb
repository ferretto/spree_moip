class CreateSpreeMoipTokens < ActiveRecord::Migration
  def change
    create_table :spree_moip_tokens do |t|
      t.text :token
      t.references :order, index: true

      t.timestamps
    end
  end
end

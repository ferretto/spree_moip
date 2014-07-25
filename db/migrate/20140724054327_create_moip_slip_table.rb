class CreateMoipSlipTable < ActiveRecord::Migration
  def self.up
    create_table :spree_moip_slips, :force => true do |t|
      t.date      :due_date
      t.references   :order
      t.string    :status
      t.decimal   :amount, :precision => 10, :scale => 2
      t.datetime  :paid_at
      t.text      :payload
      t.string    :document_number
      t.timestamps
    end
  end

  def self.down
    drop_table :spree_moip_slips
  end
end

class CreateEntryFees < ActiveRecord::Migration
  def change
    create_table :entry_fees do |t|
      t.integer :entry_id
      t.integer :entry_fee_id
      t.boolean :paid

      t.timestamps
    end
  end
end

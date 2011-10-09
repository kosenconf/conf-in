class RemoveEntryFeeIdFromEntryFees < ActiveRecord::Migration
  def up
    remove_column :entry_fees, :entry_fee_id
  end

  def down
    add_column :entry_fees, :entry_fee_id, :integer
  end
end

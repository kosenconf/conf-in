class AddEventFeeIdToEntryFees < ActiveRecord::Migration
  def change
    add_column :entry_fees, :event_fee_id, :integer
  end
end

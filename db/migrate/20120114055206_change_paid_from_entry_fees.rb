class ChangePaidFromEntryFees < ActiveRecord::Migration
  def up
    change_column_default 'entry_fees', 'paid', false
  end

  def down
    change_column_default 'entry_fees', 'paid'
  end
end

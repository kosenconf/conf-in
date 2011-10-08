class RemoveExpenseFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :expense
  end

  def down
    add_column :events, :expense, :decimal
  end
end

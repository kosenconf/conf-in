class AddTwIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tw_id, :string
  end
end

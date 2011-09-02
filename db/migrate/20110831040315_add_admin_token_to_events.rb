class AddAdminTokenToEvents < ActiveRecord::Migration
  def change
    add_column :events, :admin_token, :string
		add_index :events, :admin_token, unique: true
	end
end

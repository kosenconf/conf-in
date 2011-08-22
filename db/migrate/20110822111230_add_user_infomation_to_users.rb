class AddUserInfomationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :memo, :text
    add_column :users, :website, :string
    add_column :users, :qr_secret, :string
    add_column :users, :job, :string
    add_column :users, :office, :string
    add_column :users, :domicile, :string
  end
end

class AddLatAndLngToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lat, :float
    add_column :users, :lng, :float
  end
end

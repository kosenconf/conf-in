class AddTwiconUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twicon_url, :string
  end
end

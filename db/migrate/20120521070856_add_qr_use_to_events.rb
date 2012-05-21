class AddQrUseToEvents < ActiveRecord::Migration
  def change
    add_column :events, :qr_use, :boolean

  end
end

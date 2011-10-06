class CreateEventFees < ActiveRecord::Migration
  def change
    create_table :event_fees do |t|
      t.integer :event_id
      t.string :name
      t.integer :sum
      t.text :summary

      t.timestamps
    end
  end
end

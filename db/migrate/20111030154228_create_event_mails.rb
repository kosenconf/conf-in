class CreateEventMails < ActiveRecord::Migration
  def change
    create_table :event_mails do |t|
      t.integer :event_id
      t.string :subject
      t.text :text

      t.timestamps
    end
  end
end

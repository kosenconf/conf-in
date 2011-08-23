class CreateEntries < ActiveRecord::Migration
	def change
		create_table :entries do |t|
			t.integer  "event_id"
			t.integer  "user_id"

			t.string   "select1"
			t.string   "select2"
			t.string   "select3"
			t.string   "select4"
			t.string   "select5"
			t.text     "free1"
			t.text     "free2"
			t.text     "free3"
			t.text     "free4"
			t.text     "free5"

			t.text     "comment"

			t.integer  "received"

			t.timestamps
		end
	end
end

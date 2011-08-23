class CreateEvents < ActiveRecord::Migration
	def change
		create_table :events do |t|
			t.string   "name"
			t.datetime "date"
			t.text     "summary"
			t.string   "website"

			t.string   "place_name"
			t.string   "place_room"
			t.string   "place_address"
			t.string   "place_website"

			t.integer  "capacity"
			t.decimal  "expense"

			t.datetime "joinable_period_begin"
			t.datetime "joinable_period_end"
			
			t.string   "hosting_group"
			t.string   "hosting_email"

			t.integer  "main_event_id"
			t.integer  "owner_user_id"

			t.string   "select1"
			t.string   "select2"
			t.string   "select3"
			t.string   "select4"
			t.string   "select5"

			t.string   "select_content1"
			t.string   "select_content2"
			t.string   "select_content3"
			t.string   "select_content4"
			t.string   "select_content5"

			t.integer  "select_setting1"
			t.integer  "select_setting2"
			t.integer  "select_setting3"
			t.integer  "select_setting4"
			t.integer  "select_setting5"


			t.string   "free1"
			t.string   "free2"
			t.string   "free3"
			t.string   "free4"
			t.string   "free5"

			t.integer  "free_setting1"
			t.integer  "free_setting2"
			t.integer  "free_setting3"
			t.integer  "free_setting4"
			t.integer  "free_setting5"

			t.timestamps
		end
	end
end

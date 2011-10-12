class HomeController < ApplicationController
  def index
    #向こう１週間で参加登録が終了するイベント
    @near_closing_events = Event.find(
      :all,
      :order => "joinable_period_end DESC",
      :conditions => ["joinable_period_end <= ? AND joinable_period_end >= ?", 7.day.since, Time.now.utc ],
      :limit => 5 #5件
    )

		#開催されるイベント
    @near_events = Event.find(
      :all,
      :order => "date DESC", #降順で
      :conditions => ["date >= ?", Time.now.utc],
      :limit => 5 #5件
    )
	end
	
	def about
	end
end

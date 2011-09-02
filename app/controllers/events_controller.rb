# coding: utf-8
class EventsController < ApplicationController
  #SSL Required
  #ssl_required :admin, :csv, :xml if RAILS_ENV == "production"
  #認証要求（一覧と表示以外）
  before_filter :authenticate_user!, :except => [:index, :show, :map, :admin, :csv, :xml]
  before_filter :find_event_by_token, only: [:edit, :update]
  #layout "events", :except => [:map]


  # GET /events
  def index
    @events = Event.all
    @page_title = "イベント一覧"
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @events.to_xml(:include => [:entries] ) }
    end
  end

  # GET /events/1
  def show
    @event = Event.find(params[:id]) #1行取得
    @page_title = @event.name
    #サブイベント取得（無いときnil）
    @sub_events = @event.sub_events
    #アクセスしたこのイベントにユーザが参加しているか
    @entry = current_user.entries.find_by_event_id(@event.id) if user_signed_in?
    #エントリー
    @entries = @event.entries
    #主催者の取得
    @owner_user = @event.owner_user
    #残り参加可能人数計算
    @remain = @event.capacity - @event.entries.all.count

    #イベントの状態
    @status = if Time.now < @event.joinable_period_begin then "準備中"
        elsif Time.now < @event.joinable_period_end then "申込受付中"
        elsif Time.now < @event.date then "申込受付終了"
        else "イベント終了"
      end

    respond_to do |format|
      format.html # show.html.erb
#      format.xml  { render :xml => @event.to_xml(:include => [:entries] )}
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    @page_title = "新規イベント作成"
    @event.owner_user_id = current_user.id
  end

  # POST /events
  def create
    @event = Event.new(params[:event])
    @event.owner_user_id = current_user.id
    #@event.owner_user_id = 1
    
    respond_to do |format|
      if @event.save
        format.html {
          redirect_to(@event, :notice => 'イベントは作成されました。') }
        #format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

	# GET /events/admin_token
	# admin_tokenをIDとして利用
	def edit
		@page_title = "イベント編集 | #{@event.name}"

		@is_current_user_admin = current_user.hosted_events.find_by_id(@event.id)
	end

	# PUT /events/admin_token
	# admin_tokenをIDとして利用
	def update
		respond_to do |format|
			if @event.update_attributes(params[:event])
				format.html {
					redirect_to(@event, notice: 'イベントは編集されました。')
				}
			else
				format.html {
					render action: :edit
				}
			end
		end
	rescue
		redirect_to action: 'index'
	end


  # DELETE /events/admin_token
	# admin_tokenがパラメータ
  def destroy
    #パラメータ
    token = params[:id]
    #カレントユーザのホストイベントから検索
    @event = current_user.hosted_events.find_by_admin_token(token) or
			raise ActiveRecord::RecordNotFound
    #@event = Event.find(id)
    
    #イベント削除
    @event.destroy

    #トップページへリダイレクト
    redirect_to "/"
  rescue
    #失敗orアクセス権限なし
    #showページへリダイレクト
    redirect_to :action => "show"
  end

	# Google Mapsによる地図表示
  def map
    @event = Event.find(params[:id])

		render layout: false
  end


private

	# admin_tokenでイベントを検索
	def find_event_by_token
		@event = Event.find_by_admin_token(params[:id]) or
			raise ActiveRecord::RecordNotFound
	rescue
		redirect_to '/'
	end
end


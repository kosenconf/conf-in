# coding: utf-8
class EventsController < ApplicationController
  #認証要求
  before_filter :authenticate_user!, :except => [:index, :show, :map, :admin]
  
  # idによるイベント検索
  before_filter :find_event, except: [:index, :new, :create, :destroy]
  
  # admin_tokenによる認証
  # ミス防止のために，フィルタしないものを指定
  before_filter :authenticate_by_admin_token!,
    except: [:index, :show, :new, :create, :destroy, :map]

  # BASIC認証
	before_filter :basic_auth, only: [:new, :create] if ENV['RAILS_ENV'] == 'production'
  
  # レスポンス
  respond_to :html
  
  # GET /events
  def index
    @events = Event.all
    @page_title = "イベント一覧"
    
    # レスポンス
    respond_with @events
  end

  # GET /events/1
  def show
    #@event = Event.find(params[:id]) #1行取得
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
    # 参加費用リスト
    @event_fees = @event.event_fees
    
    # 参加費用合計
    @entrysum = @entry.fees_sum if @entry

    #イベントの状態
    @status = if Time.now < @event.joinable_period_begin then "準備中"
        elsif Time.now < @event.joinable_period_end then "申込受付中"
        elsif Time.now < @event.date then "申込受付終了"
        else "イベント終了"
      end
    
    # レスポンス
    respond_with @event
  end

  # GET /events/new
  def new
    @event = Event.new
    @page_title = "新規イベント作成"
    @event.owner_user_id = current_user.id
    
    # 1つ参加費用のフィールドを用意
    1.times do
      @event.event_fees.build
    end
    
    # レスポンス
    respond_with @event
  end

  # POST /events
  def create
    @event = Event.new(params[:event])
    @event.owner_user_id = current_user.id
    
    # レスポンス
    respond_with @event do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'イベントは作成されました。' }
      end
    end
  end

	# GET /events/:id/?admin_token=:admin_token
	def edit
		@page_title = "イベント編集 | #{@event.name}"

		@is_current_user_admin = current_user.hosted_events.find_by_id(@event.id)
		
		# レスポンス
		respond_with @event
	end

	# PUT /events/:id
	def update
	  # レスポンス
    respond_with @event do |format|
      if @event.update_attributes(params[:event])
        # 正常時はイベントページへリダイレクト
        format.html { redirect_to @event, notice: 'イベントは編集されました。' }
      end
    end
	end


  # DELETE /events/:id
  def destroy
    #カレントユーザのホストイベントから検索
    @event = current_user.hosted_events.find(params[:id])

    #イベント削除
    @event.destroy

    #トップページへリダイレクト
    redirect_to root_path
  rescue
    #失敗orアクセス権限なし
    #showページへリダイレクト
    redirect_to action: :show,
      notice: "イベント作成者以外はイベントを削除することはできません．"
  end

	# Google Mapsによる地図表示
  def map
		render layout: false
  end
  
  # GET /events/:id/admin?admin_token=:admin_token
  # イベント管理者ページ
  # 機能としてはリンクページのみ
  def admin
  end

private
  # イベントIDからイベントを取得
  def find_event
    @event = Event.find(params[:id])
  end
  
  # イベント管理者ページのトークン認証
  def authenticate_by_admin_token!
    redirect_to root_path unless @event.admin_token == params[:admin_token]
  end
	
	# Basic認証
	def basic_auth
		authenticate_or_request_with_http_basic do |user, pass|
			user == 'kc035NagaokaAdmin' && pass == 'A6JkSLxBg3EPTtPu'
		end
	end
end


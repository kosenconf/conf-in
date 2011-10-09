# coding: utf-8
class EntriesController < ApplicationController
  # SSLへリダイレクト
  #ssl_required :new, :confirm, :complete, :ticket, :xml if RAILS_ENV == "production"
  
  # 認証要求
  before_filter :authenticate_user!
  
  # イベント情報を引っ張る
  before_filter :find_event, except: [:index]
  before_filter :find_event_by_admin_token, only: [:index]
  
  # 定員に達したか？
  before_filter :entries_filled,
    :only => [ :new, :create, :confirm, :complete ]
 
  # 受付期間内か？
  before_filter :can_entry,
    :only => [ :new, :create, :confirm, :complete, :destroy ]

  
  # GET /entries/new
  # イベント参加登録
  def new
    @entry = Entry.new
    @user_id = current_user.id
    @page_title = "イベントに参加 | #{@event.name}"
    # EventFeeを取得
    @fees = @event.fees
    
    # EventFee分作成
    @fees.each do
      @entry.fees.build
    end
  end
  
  # POST /entries/confirm
  # 参加登録内容の確認
  def confirm
    @entry = Entry.new(params[:entry])
    @page_title = "確認 | #{@event.name}"

    @entry.event_id = @event_id
    @entry.user_id = current_user.id

    if @entry.valid?
      render :action => 'confirm'
    else
      render :action => 'new'
    end
  end

  # POST /entries/complete
  # 参加登録完了
  def complete

    @entry = Entry.new(params[:entry])
    @entry.user_id = current_user.id

    @page_title = "参加登録完了 | #{@event.name}"
    
    if (@event.entries << @entry)
      render :action => 'complete'
      EntryMailer.new_entry_user(@entry).deliver
      EntryMailer.notify_new_entry_to_owner(@entry).deliver
    else
      #render :action => :new
      redirect_to event_url(@event)
    end
  end
  
  # POST /entries/ticket
  # チケットの描画
  def ticket
    @entry = Entry.new(params[:entry])
    @entry.user_id = current_user.id

    render :action => 'ticket'
  end
  
  # DELETE /entries/1
  # 参加登録の解除
  def destroy
    #パラメータ
    id = params[:id]
    #カレントユーザの参加イベントから検索
    @entry = current_user.entries.find(id)

    #エントリー削除
    @entry.destroy
    #@entry.save!
    #イベントページへリダイレクト
    redirect_to event_url(@event)
  rescue
    #トップページへリダイレクト
    redirect_to ('/')
  end
  
  
  # DELETE /events/:event_id/entries
  # イベント参加者一覧（管理者向け）
  # :event_idはadmin_tokenを使う
  # filterを通してイベント取得
  def index
    @page_title = "参加者一覧 | #{@event.name}"
  end
  
private
  # パラメータからイベントを取得
  def find_event
    @event_id = params[:event_id]
    return(redirect_to(events_url)) unless @event_id
    @event = Event.find(@event_id)
    
    @select_form = [
      { :answer => :select1,
        :question => @event.select1,
        :content => @event.select_content1,
        :setting => @event.select_setting1 },
      { :answer => :select2,
        :question => @event.select2,
        :content => @event.select_content2,
        :setting => @event.select_setting2 },
      { :answer => :select3,
        :question => @event.select3,
        :content => @event.select_content3,
        :setting => @event.select_setting3 },
      { :answer => :select4,
        :question => @event.select4,
        :content => @event.select_content4,
        :setting => @event.select_setting4 },
      { :answer => :select5,
        :question => @event.select5,
        :content => @event.select_content5,
        :setting => @event.select_setting5 }
    ]
    @free_form = [
      { :answer => :free1,
        :question => @event.free1,
        :setting => @event.free_setting1 },
      { :answer => :free2,
        :question => @event.free2,
        :setting => @event.free_setting2 },
      { :answer => :free3,
        :question => @event.free3,
        :setting => @event.free_setting3 },
      { :answer => :free4,
        :question => @event.free4,
        :setting => @event.free_setting4 },
      { :answer => :free5,
        :question => @event.free5,
        :setting => @event.free_setting5 }
    ]
  end

  # 定員に達したか？
  def entries_filled
    if @event.entries.all.count >= @event.capacity
      return (redirect_to (@event))
    end
  end
  
  # 受付期間内か？
  def can_entry
    unless @event.joinable_period_begin <= Time.now && Time.now <= @event.joinable_period_end
      return redirect_back_or_default(@event)
    end
  end
  
  # admin_tokenでイベントを検索
  def find_event_by_admin_token
    @event = Event.find_by_admin_token(params[:event_id]) or
      raise ActiveRecord::RecordNotFound
  rescue
    redirect_to '/'
  end
end

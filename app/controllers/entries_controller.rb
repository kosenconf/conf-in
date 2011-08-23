# coding: utf-8
class EntriesController < ApplicationController
  #SSL Required
  #ssl_required :new, :confirm, :complete, :ticket, :xml if RAILS_ENV == "production"
  #認証要求
  #before_filter :login_required, :except => [:xml]
  #before_filter :login_from_basic_auth, :if => :is_format_xml?
  before_filter :authenticate_user!
  #イベント情報を引っ張る
  before_filter :find_event
  #定員に達したか？
  before_filter :entries_filled,
    :only => [ :new, :create, :confirm, :complete, :destroy ]
  #受付期間内か？
  before_filter :can_entry,
    :only => [ :new, :create, :confirm, :complete, :destroy ]
  #before_filter :auth, :only => :xml
#  def index
#    @entries = @event.entries
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @entries }
#    end
#  end
=begin
  #データ
  def xml
    #@user = User.find(params[:id])
    @entries = Entry.all()
    #render #:xml => entries
    render :layout => false
  end
=end
  
  # GET /entries/new
  # GET /entries/new.xml
  def new
    @entry = Entry.new
    @user_id = current_user.id
    @page_title = "イベントに参加 | #{@event.name}"
  end

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

  # POST /entries
  # POST /entries.xml
#  def create
#    @entry = Entry.new(params[:entry])
#    @entry.user_id = @user_id
#    #ハッシュ発行
#    #一応一意になるまで発行
#    until Entry.find_by_secret_id(@entry.secret_id = SecureRandom.base64(8)).nil?
#    end
#
#    if (@event.entries << @entry)
#      EntryMailer.deliver_complete(@entry)
#      EntryMailer.deliver_user_entried(@entry)
#      #redirect_to event_url(@event)
#      redirect_to complete_url(@entry)
#    else
#      render :action => :new
#    end
#  end
  
  def complete
    @sub_events = @event.sub_events

    @entry = Entry.new(params[:entry])
    @entry.user_id = current_user.id

    @page_title = "参加登録完了 | #{@event.name}"
    
    if (@event.entries << @entry)
      render :action => 'complete'
    else
      #render :action => :new
      redirect_to event_url(@event)
    end
  end

  def ticket
    @entry = Entry.new(params[:entry])
    @entry.user_id = current_user.id

    render :action => 'ticket'
  end
  
  # DELETE /entries/1
  # DELETE /entries/1.xml
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
    redirect_back_or_default('/')
  end

  private

  def find_event
    @event_id = params[:event_id]
    return(redirect_to(events_url)) unless @event_id
    @event = Event.find(@event_id)

  end

  #定員に達したか？
  def entries_filled
    if @event.entries.all.count >= @event.capacity
      return (redirect_back_or_default(@event))
    end
  end
  
  def can_entry
    unless @event.joinable_period_begin <= Time.now && Time.now <= @event.joinable_period_end
      return redirect_back_or_default(@event)
    end
  end

  def is_format_xml?
    params[:format] == "xml"
  end

  def auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == $ADMIN_USER && pass == $ADMIN_PASS
    end
  end
end

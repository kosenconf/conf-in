# coding: utf-8
class EventsController < ApplicationController
  #SSL Required
  #ssl_required :admin, :csv, :xml if RAILS_ENV == "production"
  #認証要求（一覧と表示以外）
  #before_filter :login_required, :except => [:index, :show, :map, :admin, :csv, :xml]
  #before_filter :auth, :only => [:new, :create, :admin, :csv, :xml]
  #before_filter :login_from_basic_auth, :only => [:index, :show],
  #  :if => :is_format_xml?
  
  #layout "events", :except => [:map]

  $select_form = [
      { :question => :select1, :content => :select_content1,
        :setting => :select_setting1 },
      { :question => :select2, :content => :select_content2,
        :setting => :select_setting2 },
      { :question => :select3, :content => :select_content3,
        :setting => :select_setting3 },
      { :question => :select4, :content => :select_content4,
        :setting => :select_setting4 },
      { :question => :select5, :content => :select_content5,
        :setting => :select_setting5 }
    ]
    $free_form = [
      { :question => :free1, :setting => :free_setting1 },
      { :question => :free2, :setting => :free_setting2 },
      { :question => :free3, :setting => :free_setting3 },
      { :question => :free4, :setting => :free_setting4 },
      { :question => :free5, :setting => :free_setting5 }
    ]

  #データ
=begin
  def xml
    #@user = User.find(params[:id])
    @events = Event.all()
    render :layout => false
    #render :xml => events
  end
=end

  # GET /events
  # GET /events.xml
  def index
    @events = Event.all
    @page_title = "イベント一覧"
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @events.to_xml(:include => [:entries] ) }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id]) #1行取得
    @page_title = #{@event.name}
    #サブイベント取得（無いときnil）
    @sub_events = @event.sub_events
    #アクセスしたこのイベントにユーザが参加しているか
    @entry = current_user.entries.find_by_event_id(@event.id) if logged_in?
    #エントリー
    @entries = @event.entries
    #主催者の取得
    @owner_user = @event.owner_user
    #残り参加可能人数計算
    @remain = @event.capacity - @event.entries.all.count

    #イベントの状態
    @status = if Time.now < @event.join_begin then "準備中"
        elsif Time.now < @event.join_end then "申込受付中"
        elsif Time.now < @event.date then "申込受付終了"
        else "イベント終了"
      end

    respond_to do |format|
      format.html # show.html.erb
#      format.xml  { render :xml => @event.to_xml(:include => [:entries] )}
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @page_title = "新規イベント作成"
    @event.host_id = current_user.id
  end

  # GET /events/1/edit
  def edit
    id = params[:id]
    #カレントユーザのホストイベントから検索
    @event = current_user.hosted_events.find(id)
    @page_title = "イベント編集 | #{@event.name}"
  rescue
    #失敗orアクセス権限なし
    #showページへリダイレクト
    redirect_to :action => "show"
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.host_id = current_user.id

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

  # PUT /events/1
  # PUT /events/1.xml
  def update
    id = params[:id]
    #カレントユーザのホストイベントから検索
    @event = current_user.hosted_events.find(id)

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html {
          redirect_to(@event, :notice => 'イベントは編集されました。') }
        #format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        #format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end

  rescue
    #失敗orアクセス権限なし
    #showページへリダイレクト
    redirect_to :action => "show"
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    #パラメータ
    id = params[:id]
    #カレントユーザのホストイベントから検索
    @event = current_user.hosted_events.find(id)
    
    #イベント削除
    @event.destroy

    #トップページへリダイレクト
    redirect_to "/"
  rescue
    #失敗orアクセス権限なし
    #showページへリダイレクト
    redirect_to :action => "show"
  end

=begin
  def map
    @event = Event.find(params[:id])
  end


  def admin
    id = params[:id]
    #@event = RAILS_ENV == "production" ? current_user.hosted_events.find(id) : Event.find(params[:id])
    @event = Event.find(id)
    @page_title = "イベント管理 | #{@event.name}"

  rescue
    redirect_to "/"
  end
=end

=begin
  def csv
    require 'csv'
    id = params[:id]
    @event = Event.find(id)
    CSV::Writer.generate(output = "") do |csv|
      subevents = []
      @event.sub_events.each do |subevent|
        subevents << subevent.name
      end
      select = []
      $select_form.each do |sel|
        select << @event[sel[:question]]  unless @event[sel[:setting]] == 0
      end
      free = []
      $free_form.each do |fre|
        free << @event[fre[:question]] unless @event[fre[:setting]] == 0
      end
      csv << ['エントリID', 'ニックネーム', 'E-Mail', 'ひと言'] + subevents + select + free

      @event.entries.each do |entry|
        subevent = []
        @event.sub_events.each do |sub|
          subevent << (sub.entries.find_by_user_id(entry.user_id) ? '○':'×')
        end
        
        select = []
        $select_form.each do |sel|
          select << entry[sel[:question]]  unless @event[sel[:setting]] == 0
        end
        free = []
        $free_form.each do |fre|
          free << entry[fre[:question]] unless @event[fre[:setting]] == 0
        end
        
        csv << [
          entry.id, entry.user.nickname, entry.user.email,
          entry.comment
        ] + subevent + select + free


      end

    end

    #output = Iconv.conv('SJIS', 'UTF-8', output)
    output = NKF.nkf('-U -s -Lw', output)
    send_data(output, :type=>'text/csv', 
      :filename=>"#{@event.name}_#{Time.now.strftime('%Y%m%d_%H%M%S')}.csv")

  #rescue
  # redirect_to "/"
  end
=end

  private
=begin
  def is_format_xml?
    params[:format] == "xml"
  end

  def auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == $ADMIN_USER && pass == $ADMIN_PASS
    end
  end
=end

end

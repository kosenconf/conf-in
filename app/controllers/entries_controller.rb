# coding: utf-8
require 'csv'
require 'kconv'
class EntriesController < ApplicationController
  # 認証要求
  before_filter :authenticate_user!, except: [ :qr_receive, :update, :index ]
  
  # イベント情報を引っ張る
  before_filter :find_event
  
  # admin_tokenによる認証
  # ミス防止のために，フィルタしないものを指定
  before_filter :authenticate_by_admin_token!,
    except: [:new, :confirm, :complete, :ticket, :destroy]
  
  # 定員に達したか？
  before_filter :entries_filled,
    :only => [ :new, :create, :confirm, :complete ]
 
  # 受付期間内か？
  before_filter :can_entry,
    :only => [ :new, :create, :confirm, :complete, :destroy ]
  
  # 既に参加しているかどうか
  before_filter :already_has_joined, only: [:new, :confirm, :complete]
  
  # GET /entries/new
  # イベント参加登録
  def new
    @entry = Entry.new
    @user_id = current_user.id
    @page_title = "イベントに参加 | #{@event.name}"
    
    # EventFeeを取得
    @event_fees = @event.event_fees
    @fee_ids = []
    @entry.entry_fees.each do |f|
      @fee_ids << f.event_fee_id
    end
  end
  
  # POST /entries/confirm
  # 参加登録内容の確認
  def confirm
    @entry = Entry.new(params[:entry])
    @page_title = "確認 | #{@event.name}"

    @entry.event_id = @event_id
    @entry.user_id = current_user.id

    # EventFeeを取得
    @event_fees = @event.event_fees
    @fee_ids = []
    @entry.entry_fees.each do |f|
      @fee_ids << f.event_fee_id
    end
    
    if @entry.valid?
      render :action => 'confirm'
    else
      render :action => 'new'
    end
  end

  # POST /entries/complete
  # 参加登録完了
  def complete
    @sub_events = @event.sub_events

    @entry = Entry.new(params[:entry])
    @entry.user_id = current_user.id
    @entry_fees = @entry.entry_fees

    @page_title = "参加登録完了 | #{@event.name}"
    
    if (@event.entries << @entry)
      render :action => 'complete'
      EntryMailer.new_entry_user(@entry).deliver
      #EntryMailer.notify_new_entry_to_owner(@entry).deliver
    else
      #render :action => :new
      redirect_to event_path(@event)
    end
  end

  # PUT /entries/1
  # 当日受付情報の更新
  def update
    @user = @event.users.find_by_qr_secret(params[:qr_secret])
    @entry = @event.entries.find_by_user_id(@user.id)
    
    @entry.update_attributes(params[:entry])
    
    #redirect_to :back
    render "entry_fees_table.js"
  rescue
    redirect_to root_path
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
    redirect_to event_path(@event),
      notice: '参加をキャンセルしました。'
  rescue
    #トップページへリダイレクト
    redirect_to root_path,
      alert: 'キャンセルに失敗しました。'
  end
  
  
  # GET /events/:event_id/entries
  # イベント参加者一覧（管理者向け）
  # :event_idはadmin_tokenを使う
  # filterを通してイベント取得
  def index
    @page_title = "参加者一覧 | #{@event.name}"
    @entries = @event.entries

    respond_to do |format|
      format.html
      format.csv do
        CSV.generate(output = "", row_sep: "\r\n") do |csv|
          @event_fees = @event.event_fees

          # 参加費用名
          fee_name = []
          @event_fees.each do |fee|
            fee_name << fee.name
          end

          # 選択アンケートの項目名
          selects  = []
          (1..5).each do |i|
            selects << @event.send("select#{i}")
          end

          # フリーアンケートの項目名
          free = []
          (1..5).each do |i|
            free << @event.send("free#{i}")
          end

          # 1行目
          csv << [
            '登録日時',
            '登録名', 'Twitter ID', '職業', '勤務先・学校', 'コメント',
            fee_name, '合計参加費用',
            selects, free
          ].flatten

          @entries.each do |entry|
            # 参加費用ごとの徴収状況
            fees_paid = []
            @event_fees.each do |fee|
              if entry_fee = entry.entry_fees.find_by_event_fee_id(fee.id)
                fees_paid << (entry_fee.paid ? '済':'未')
              else
                fees_paid << ''
              end
            end
            # 選択アンケートの回答
            selects  = []
            (1..5).each do |i|
              selects << entry.send("select#{i}")
            end
            # フリーアンケートの回答
            free = []
            (1..5).each do |i|
              free << entry.send("free#{i}")
            end
            user = entry.user
            csv << [
              entry.created_at.strftime('%Y/%m/%d %H:%M:%S'),
              user.name, user.tw_id, user.job, user.office, entry.comment,
              fees_paid, entry.fees_sum,
              selects, free
            ].flatten
          end
        end
 
        send_data NKF.nkf('-sxm0', output), type: 'text/csv',
          filename: "#{@event.id}(#{Time.now.strftime('%Y%m%d-%H%M')}).csv"
      end
    end
  end
  
  # 受付ページ
  def qr_receive
    @user = @event.users.find_by_qr_secret(params[:qr_secret])
    @entry = @event.entries.find_by_user_id(@user.id)

    @page_title = "受付情報 | #{@event.name}"

  rescue
    redirect_to root_path,
      alert: 'QRコードが間違っている、あるいは参加登録がされていません。'
  end

private
  # パラメータからイベントを取得
  def find_event
    @event_id = params[:event_id]
    unless @event_id
      return redirect_to(events_path, 
                         alert: 'イベントは削除されたもしくは存在しません。')
    end
    @event = Event.includes(:entries).find(@event_id)
    
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
      redirect_to @event,
        alert: '既に定員に達しています。'
    end
  end
  
  # 受付期間内か？
  def can_entry
    unless @event.joinable_period_begin <= Time.now && Time.now <= @event.joinable_period_end
      redirect_to @event,
        alert: '参加登録期間は開始していない、もしくは終了しています。'
    end
  end
  
  # イベント管理者ページのトークン認証
  def authenticate_by_admin_token!
    unless @event.admin_token == params[:admin_token]
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  # 既に参加しているかどうか
  def already_has_joined
    if @event.entries.find_by_user_id(current_user.id)
      redirect_to @event, alert: 'あなたは既にこのイベントに参加しています。'
    end
  end

end

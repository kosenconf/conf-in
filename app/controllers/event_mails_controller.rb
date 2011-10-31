# coding: utf-8
class EventMailsController < ApplicationController
  before_filter :find_event

  # admin_tokenによる認証
  before_filter :authenticate_by_admin_token!
  
  # GET /events/:event_id/event_mails
  # 送信済みメール一覧
  def index
    @mails = @event.event_mails
    @page_title = "メール送信履歴 | #{@event.name}"
  end

  # GET /events/:event_id/event_mails/:id
  # メールの内容
  def show
    @mail = @event.event_mails.find(params[:id])
    @page_title = "#{@mail.subject} | メール送信履歴 | #{@event.name}"
  end

  # GET /events/:event_id/event_mails/new
  # 新規メール
  def new
    @mail = @event.event_mails.new

    @page_title = "新規メール送信 | #{@event.name}"
  end

  # POST /events/:event_id/event_mails
  # 送信確認
  def confirm
    @mail = @event.event_mails.new(params[:event_mail])
    @page_title = "確認 | 新規メール送信 | #{@event.name}"
    
    if @mail.valid?
      # セッションに保存
      session[:event_mail] = @mail
      
      render action: :confirm
    else
      render action: :new,
        notice: '入力に誤りがあります。確認してください。'
    end
  end
  
  # POST /events/:event_id/event_mails
  # 送信
  def create
    # セッションから取得
    @mail = session[:event_mail]

    session[:event_mail] = nil
    if @mail.save
      # TODO: Mailer.deliver
      redirect_to event_event_mail_path(@event, @mail, admin_token: @event.admin_token),
        notice: 'メールは送信されました。'
    end
  end

private
  # イベントオブジェクトの取得
  def find_event
    @event = Event.find(params[:event_id])
  end
  
  # イベント管理者ページのトークン認証
  def authenticate_by_admin_token!
    unless @event.admin_token == params[:admin_token]
      redirect_to root_path,
        notice: 'イベント管理者認証に失敗しました．'
    end
  end
end

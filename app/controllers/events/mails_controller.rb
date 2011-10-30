class Events::MailsController < ApplicationController
  before_filter :find_event
  
  # GET /events/:event_id/mails
  # 送信済みメール一覧
  def index
    @page_title = "メール送信履歴 | #{@event.name}"
    @mails = @event.event_mails
  end

  # GET /events/:event_id/mails/:id
  # メールの内容
  def show
    @page_title = "#{@mail.subject} | メール送信履歴 | #{@event.name}"
    @mail = @event.event_mails.find(params[:id])
  end

  # GET /events/:event_id/mails/new
  # 新規メール
  def new
    @page_title = "新規メール送信 | #{@event.name}"
    @mail = @event.event_mails.new
  end

  # POST /events/:event_id/mails
  # 送信確認
  def confirm
    @page_title = "確認 | 新規メール送信 | #{@event.name}"
    @mail = @event.event_mails.new(params[:mail])
    
    if @mail.valid?
      render action: :confirm
    else
      render action: :new,
        notice: '入力に誤りがあります。確認してください。'
    end
  end
  
  # POST /events/:event_id/mails
  # 送信
  def create
    @mail = @event.event_mails.new(params[:mail])
    
    if @mail.save
      redirect_to event_mail(@mail),
        notice: 'メールは送信されました。'
    end
  end

private
  # イベントオブジェクトの取得
  def find_event
    @event = Event.find(params[:event_id])
  end
end

# coding: utf-8
class EntryMailer < ActionMailer::Base
  helper :application
  
  default from: $ADMIN_EMAIL

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.entry_mailer.new_entry_user.subject
  #
  def new_entry_user(entry)
    @entry = entry
    @event = @entry.event
    @user = @entry.user
    
    mail to: @user.email, 
      subject: "[カンファイン]#{@event.name}への参加登録が完了しました！"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.entry_mailer.notify_new_entry_to_owner.subject
  #
  def notify_new_entry_to_owner(entry)
    @entry = entry
    @event = @entry.event
    @user = @entry.user
    
    mail to: @event.hosting_email,
      subject: "[カンファイン]#{@event.name}に#{@user.name}さんが参加登録しました！"
  end
end

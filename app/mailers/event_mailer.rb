# coding: utf-8
class EventMailer < ActionMailer::Base
  default from: $ADMIN_EMAIL

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.all_entry_users.subject
  #
  def all_entry_users(mail)
    @mail = mail
    @event = @mail.event
    bcc = @event.users.map{|u| u.email}
    
    subject = "[カンファイン] #{@mail.subject}"

    mail(to: @event.hosting_email, bcc: bcc, subject: subject)
  end
end

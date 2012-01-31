# coding: utf-8
class UserMailer < ActionMailer::Base
  include ApplicationHelper

  default from: $ADMIN_EMAIL

  def send_qr(user,email)
    @user = user
    
    # QRコードの添付
    # 添付ファイル
    attachments["#{@user.id}.gif"] = qr_gif_binary(@user.qr_secret)

    mail to: email,
      subject: "[カンファイン]当日受付QRコード"
  end
end

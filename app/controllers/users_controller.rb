# coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [ :send_qr ]
  
  # ユーザの公開プロフィール表示
  def show
    @user = User.find(params[:id])
    @page_title = "#{@user.name} のプロフィール"
    @events = User.find(params[:id]).events
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  # QRコードメール送信
  def send_qr
    # Deviseのコードから拝借
    @@emailregexp = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

    email = params[:email]
    
    if email =~ @@emailregexp
      UserMailer.send_qr(current_user, email).deliver
      redirect_to :back, notice: 'QRコードを送信しました。'
    else
      redirect_to :back, alert: 'メールアドレスが不正です。'
    end
  rescue
    flash[:danger] = "送信に失敗しました。"
    redirect_to :back
  end
end

# coding: utf-8
require 'nokogiri'
require 'open-uri'

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

  def icon
    @user = User.find(params[:id])
    size = params[:size]

    unless @user.tw_id.blank?
      unless @user.twicon_url.blank?
        # twicon_url があればそのまま返す
        redirect_to view_context.twicon_url_with_size(@user.twicon_url, size)
      else
        # 取得
        url = view_context.get_raw_url(@user.tw_id)
        if url
          @user.twicon_url = view_context.original(url)
          @user.save
          redirect_to view_context.twicon_url_with_size(@user.twicon_url, size)
        else
          # 取得失敗時
          redirect_to size == :bigger ? "#{root_url}images/73.png" : "#{root_url}images/24.png"
        end
      end
    else
      # tw_idが無ければデフォルトアイコンを表示
	    redirect_to size == :bigger ? "#{root_url}images/73.png" : "#{root_url}images/24.png"
    end
  end

end

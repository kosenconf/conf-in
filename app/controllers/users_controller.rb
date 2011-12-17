# coding: utf-8

class UsersController < ApplicationController
  # ユーザの公開プロフィール表示
  def show
    @user = User.find(params[:id])
    @page_title = "#{@user.name} のプロフィール"
    @events = User.find(params[:id]).events
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end

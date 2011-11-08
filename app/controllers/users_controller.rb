# coding: utf-8

class UsersController < ApplicationController
  # ユーザの公開プロフィール表示
  def show
    @user = User.find(params[:id])
    @page_title = "#{@user.name} のプロフィール"
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end

	# Google Mapsによる地図表示
  def map
    @events = User.find(params[:id]).events
		render layout: false
  end
end

# coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [ :profile, :update ]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @page_title = "#{@user.name} のプロフィール"
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  #個人設定ページ（要認証）
  def profile
    @user = current_user
    @page_title = "プロフィール設定"
  end
  
  # GET /users/new
  # GET /users/new.json
=begin
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
=end


  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end


=begin
  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = current_user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end

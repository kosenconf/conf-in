# coding: utf-8
require 'securerandom'
class User::RegistrationsController < Devise::RegistrationsController
  
  def create
    #params[:user][:qr_secret] = SecureRandom.base64(16)
    #p params
    super
  end
end
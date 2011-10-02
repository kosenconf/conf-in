# coding: utf-8
require 'securerandom'
class Event < ActiveRecord::Base
	# 作成前の処理
	before_create :init_admin_token
  
	#エントリー
  has_many :entries,
    :dependent => :delete_all #イベントを消去した際，そのエントリをすべて抹消
  #主催者ユーザ
  belongs_to :owner_user,
    :class_name => "User",
    :foreign_key => "owner_user_id"
  #一意であるべき値
  validates_uniqueness_of :name,
    :message => "既に存在します。"
  
	#空の値をはじく
	validates_presence_of :name, :date, :place_name, :place_address,
    :capacity, :expense, :joinable_period_begin, :joinable_period_end, 
		:hosting_group, :hosting_email, :owner_user_id,
    :message => "は必須項目です。"

  #整数であるべき値
  validates_numericality_of :expense, :capacity,
    :only_integer => true, #整数でなければならない
    :message => "整数（半角数字）で入力してください。"

  validates_numericality_of :expense,
    :greater_than_or_equal_to => 0, #0 以上でなければならない
    :message => "0以上の値を入力してください。"

  validates_numericality_of :capacity,
    :greater_than => 0, #0 より大きくなければならない
    :message => "0より大きい値を入力してください。"

	# 偽造フォームによるフィールドの保護
	attr_protected :owner_user_id, :admin_token

protected
	def init_admin_token
		self.admin_token = SecureRandom.hex(16).encode('UTF-8')
	end
end

# coding: utf-8
require 'securerandom'
class Event < ActiveRecord::Base
	# 作成前の処理
	before_create :init_admin_token
  
	#エントリー
  has_many :entries,
    :dependent => :delete_all #イベントを消去した際，そのエントリをすべて抹消
  # 参加者
  has_many :users, through: :entries
  
  #主催者ユーザ
  belongs_to :owner_user,
    :class_name => "User",
    :foreign_key => "owner_user_id"

  # 参加費情報
  has_many :event_fees, dependent: :delete_all
  
  # 参加費
  has_many :entry_fees, dependent: :delete_all, through: :event_fees
  
  # 参加費フォーム
  # 名前と金額が空なら削除
  accepts_nested_attributes_for :event_fees,
    :reject_if => lambda { |f| f[:name].blank? && f[:sum].blank? },
    :allow_destroy => true

  #サブイベント
  has_many :sub_events,
    :class_name => "Event",
    :foreign_key => "main_event_id"
  #メインイベント
  belongs_to :main_event,
    :class_name => "Event",
    :foreign_key => "main_event_id"

	#一意であるべき値
  validates_uniqueness_of :name,
    :message => "既に存在します。"
  
	#空の値をはじく
	validates_presence_of :name, :date, :place_name, :place_address,
    :capacity, :joinable_period_begin, :joinable_period_end, 
		:hosting_group, :hosting_email, :owner_user_id,
    :message => "は必須項目です。"

  #整数であるべき値
  validates_numericality_of :capacity,
    :only_integer => true, #整数でなければならない
    :message => "整数（半角数字）で入力してください。"

  validates_numericality_of :capacity,
    :greater_than => 0, #0 より大きくなければならない
    :message => "0より大きい値を入力してください。"

	# 偽造フォームからのフィールドの保護
	attr_protected :owner_user_id, :admin_token
  
  # 参加者から徴収する全金額
  def all_entry_fees_sum
    sum = 0
    self.event_fees.each do |ev_fee|
      # 金額 x 人数
      sum += ev_fee.sum * ev_fee.entry_fees.all.count
    end
    return sum
  end
  
  # 一斉送信メールを持つ（ログとして残すのでイベントを消しても消さない）
  has_many :event_mails
  
protected
	def init_admin_token
		self.admin_token = SecureRandom.hex(16).encode('UTF-8')
	end

  include ActiveRecord::Calculations
end

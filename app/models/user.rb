# coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :timeoutable, :validatable

  #参加イベントエントリ
  has_many :entries,
    :class_name => "Entry",
    :foreign_key => "user_id",
    :dependent => :delete_all #ユーザを消去した際，そのユーザの参加登録を抹消
 
  #主催イベント
  has_many :hosted_events,
    :class_name => "Event",
    :foreign_key => "owner_user_id",
    :dependent => :delete_all #ユーザを消去した際，主催イベントを抹消

  #必須入力
  validates_presence_of :name, :qr_secret

  #ニックネームがユニークになるように
  validates_uniqueness_of :name,
    :message => "は既に使われています。"

  #文字数制限
  validates_length_of :name, :website, :job, :office, :domicile,
    :maximum => 40, :allow_nil => true
  validates_length_of :memo, :maximum => 200, :allow_nil => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :name, :memo, :website, :qr_secret, :job, :office, :domicile,
    :tw_uid, :tw_name, :tw_token, :tw_secret,
    :fb_token
end

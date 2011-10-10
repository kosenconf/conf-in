# coding: utf-8
class Entry < ActiveRecord::Base
  #イベント
  belongs_to :event
  #参加ユーザ
  belongs_to :user
  
  # 参加費
  has_many :fees, class_name: "EntryFee",
    foreign_key: :entry_id, dependent: :delete_all
  # 参加費フォーム
  # 名前と金額が空なら削除
  accepts_nested_attributes_for :fees,
    :reject_if => lambda { |f| f[:event_fee_id].blank? }
  
  #空の値をはじく
  validates_presence_of :event_id, :user_id,
    :message => "は必須項目です。"
  #ユーザ名が一意になるように
  validates_uniqueness_of :user_id,
    :scope => "event_id", #イベント内で一意
    :message => "あなたは既にこのイベントに参加登録しています。"

  #ひと言の文字数制限
  validates_length_of :comment, :maximum => 30

  #アンケートの設定に応じた必須項目の設定
  validates_presence_of :select1, :if => Proc.new { |e| e.event.select_setting1 == 2 }
  validates_presence_of :select2, :if => Proc.new { |e| e.event.select_setting2 == 2 }
  validates_presence_of :select3, :if => Proc.new { |e| e.event.select_setting3 == 2 }
  validates_presence_of :select4, :if => Proc.new { |e| e.event.select_setting4 == 2 }
  validates_presence_of :select5, :if => Proc.new { |e| e.event.select_setting5 == 2 }
  validates_presence_of :free1, :if => Proc.new { |e| e.event.free_setting1 == 2 }
  validates_presence_of :free2, :if => Proc.new { |e| e.event.free_setting2 == 2 }
  validates_presence_of :free3, :if => Proc.new { |e| e.event.free_setting3 == 2 }
  validates_presence_of :free4, :if => Proc.new { |e| e.event.free_setting4 == 2 }
  validates_presence_of :free5, :if => Proc.new { |e| e.event.free_setting5 == 2 }

  #フリーアンケートの文字数制限
  validates_length_of :free1, :maximum => 400, :allow_nil => true
  validates_length_of :free2, :maximum => 400, :allow_nil => true
  validates_length_of :free3, :maximum => 400, :allow_nil => true
  validates_length_of :free4, :maximum => 400, :allow_nil => true
  validates_length_of :free5, :maximum => 400, :allow_nil => true

  # receivedの整形
  def received_to_s
    i = self.received || 0
    %w(未確認 出席 欠席)[i]
  end

=begin
private
  def user_exsist?
    errors.add(:user_id, "ユーザは存在しません。") unless User.find_by_id(user_id)
  end
=end

end

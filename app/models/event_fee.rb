# coding: utf-8
class EventFee < ActiveRecord::Base
  # EntryFeesを持つ
  has_many :entry_fees, dependent: :delete_all
  # Eventに属する
  belongs_to :event

  # nameフィールドの検証
  validates :name,
    presence: true

  # sumフィールドの検証
  validates :sum,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }

  # 偽造フォームからのフィールドの保護
  attr_protected :paid

end

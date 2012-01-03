class EventMail < ActiveRecord::Base
  # Eventに従属
  belongs_to :event

  # subjectフィールドの検証
  validates :subject,
    presence: true,
    length: { maximum: 30 }

  # textフィールドの検証
  validates :text,
    presence: true,
    length: { maximum: 2000 }

  # 保護
  attr_protected :event_id
end

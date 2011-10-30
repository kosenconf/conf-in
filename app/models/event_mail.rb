class EventMail < ActiveRecord::Base
  # Eventに従属
  belongs_to :event

  # subjectフィールドの検証
  validates :subject, presence: true

  # textフィールドの検証
  validates :text, presence: true

  # 保護
  attr_protected :event_id
end

class EntryFee < ActiveRecord::Base
  # EventFeeに属する
  belongs_to :event_fee
  # Entryに属する
  belongs_to :entry

  validates_presence_of :event_fee_id
end

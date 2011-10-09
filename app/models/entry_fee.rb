class EntryFee < ActiveRecord::Base
  # EventFeeに属する
  belongs_to :event_fee
  # Entryに属する
  belongs_to :entry
end

require 'test_helper'

class EventMailTest < ActiveSupport::TestCase
  test "invalid with empty attributes" do
    event_mail = EventMail.new
    assert event_mail.invalid?
  end
end

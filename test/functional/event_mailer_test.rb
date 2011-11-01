require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  test "all_entry_users" do
    mail = EventMailer.all_entry_users
    assert_equal "All entry users", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

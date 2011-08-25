require 'test_helper'

class EntryMailerTest < ActionMailer::TestCase
  test "new_entry_user" do
    mail = EntryMailer.new_entry_user
    assert_equal "New entry user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "notify_new_entry_to_owner" do
    mail = EntryMailer.notify_new_entry_to_owner
    assert_equal "Notify new entry to owner", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

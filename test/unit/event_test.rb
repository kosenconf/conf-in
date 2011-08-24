require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    # Success Pattern 1
    @sp1 = events(:sp1)
    # Failed Pattern 1
    #@fp1 = events(:fp1)
    @fp2 = events(:fp2)
  end
  
  test "event_should_save" do
    assert @sp1.save, 'Failed to save'
  end

  test "event_validates_presence_of" do
    assert !@fp2.save, 'Failed to validate'
    # presenceでは11個だが，numericalityで4つあるので計15個
    assert_equal @fp2.errors.size, 15, 'Failed to validate count'
    assert @fp2.errors[:name].any?, 'Failed to name vaildate'
  end
  
  
end

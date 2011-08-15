# Home#index の単体テスト
# Author:: Hayato OKUMOTO
# Date:: Mon, Aug 15 2011

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
	# 正しいレスポンスの検証
	test "should get index" do
    get :index
    assert_response :success
  end
end

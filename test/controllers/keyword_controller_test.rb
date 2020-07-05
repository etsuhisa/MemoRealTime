require 'test_helper'

class KeywordControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get keyword_index_url
    assert_response :success
  end

end

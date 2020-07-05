require 'test_helper'

class HashTagControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hash_tag_index_url
    assert_response :success
  end

end

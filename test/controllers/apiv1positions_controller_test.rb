require "test_helper"

class Apiv1positionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get apiv1positions_index_url
    assert_response :success
  end

  test "should get create" do
    get apiv1positions_create_url
    assert_response :success
  end

  test "should get show" do
    get apiv1positions_show_url
    assert_response :success
  end

  test "should get update" do
    get apiv1positions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get apiv1positions_destroy_url
    assert_response :success
  end
end

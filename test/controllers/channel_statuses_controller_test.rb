require "test_helper"

class ChannelStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel_status = channel_statuses(:one)
  end

  test "should get index" do
    get channel_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_channel_status_url
    assert_response :success
  end

  test "should create channel_status" do
    assert_difference("ChannelStatus.count") do
      post channel_statuses_url, params: { channel_status: { channel_id: @channel_status.channel_id, status_id: @channel_status.status_id } }
    end

    assert_redirected_to channel_status_url(ChannelStatus.last)
  end

  test "should show channel_status" do
    get channel_status_url(@channel_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_channel_status_url(@channel_status)
    assert_response :success
  end

  test "should update channel_status" do
    patch channel_status_url(@channel_status), params: { channel_status: { channel_id: @channel_status.channel_id, status_id: @channel_status.status_id } }
    assert_redirected_to channel_status_url(@channel_status)
  end

  test "should destroy channel_status" do
    assert_difference("ChannelStatus.count", -1) do
      delete channel_status_url(@channel_status)
    end

    assert_redirected_to channel_statuses_url
  end
end

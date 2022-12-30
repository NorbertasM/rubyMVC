require "test_helper"

class PreviewStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @preview_status = preview_statuses(:one)
  end

  test "should get index" do
    get preview_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_preview_status_url
    assert_response :success
  end

  test "should create preview_status" do
    assert_difference("PreviewStatus.count") do
      post preview_statuses_url, params: { preview_status: { channel_id: @preview_status.channel_id, preview_id: @preview_status.preview_id, valid_until: @preview_status.valid_until } }
    end

    assert_redirected_to preview_status_url(PreviewStatus.last)
  end

  test "should show preview_status" do
    get preview_status_url(@preview_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_preview_status_url(@preview_status)
    assert_response :success
  end

  test "should update preview_status" do
    patch preview_status_url(@preview_status), params: { preview_status: { channel_id: @preview_status.channel_id, preview_id: @preview_status.preview_id, valid_until: @preview_status.valid_until } }
    assert_redirected_to preview_status_url(@preview_status)
  end

  test "should destroy preview_status" do
    assert_difference("PreviewStatus.count", -1) do
      delete preview_status_url(@preview_status)
    end

    assert_redirected_to preview_statuses_url
  end
end

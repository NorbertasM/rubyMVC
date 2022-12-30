require "test_helper"

class ChannelTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel_tag = channel_tags(:one)
  end

  test "should get index" do
    get channel_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_channel_tag_url
    assert_response :success
  end

  test "should create channel_tag" do
    assert_difference("ChannelTag.count") do
      post channel_tags_url, params: { channel_tag: { channel_id: @channel_tag.channel_id, tag_id: @channel_tag.tag_id } }
    end

    assert_redirected_to channel_tag_url(ChannelTag.last)
  end

  test "should show channel_tag" do
    get channel_tag_url(@channel_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_channel_tag_url(@channel_tag)
    assert_response :success
  end

  test "should update channel_tag" do
    patch channel_tag_url(@channel_tag), params: { channel_tag: { channel_id: @channel_tag.channel_id, tag_id: @channel_tag.tag_id } }
    assert_redirected_to channel_tag_url(@channel_tag)
  end

  test "should destroy channel_tag" do
    assert_difference("ChannelTag.count", -1) do
      delete channel_tag_url(@channel_tag)
    end

    assert_redirected_to channel_tags_url
  end
end

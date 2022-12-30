require "application_system_test_case"

class ChannelTagsTest < ApplicationSystemTestCase
  setup do
    @channel_tag = channel_tags(:one)
  end

  test "visiting the index" do
    visit channel_tags_url
    assert_selector "h1", text: "Channel tags"
  end

  test "should create channel tag" do
    visit channel_tags_url
    click_on "New channel tag"

    fill_in "Channel", with: @channel_tag.channel_id
    fill_in "Tag", with: @channel_tag.tag_id
    click_on "Create Channel tag"

    assert_text "Channel tag was successfully created"
    click_on "Back"
  end

  test "should update Channel tag" do
    visit channel_tag_url(@channel_tag)
    click_on "Edit this channel tag", match: :first

    fill_in "Channel", with: @channel_tag.channel_id
    fill_in "Tag", with: @channel_tag.tag_id
    click_on "Update Channel tag"

    assert_text "Channel tag was successfully updated"
    click_on "Back"
  end

  test "should destroy Channel tag" do
    visit channel_tag_url(@channel_tag)
    click_on "Destroy this channel tag", match: :first

    assert_text "Channel tag was successfully destroyed"
  end
end

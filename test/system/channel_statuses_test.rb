require "application_system_test_case"

class ChannelStatusesTest < ApplicationSystemTestCase
  setup do
    @channel_status = channel_statuses(:one)
  end

  test "visiting the index" do
    visit channel_statuses_url
    assert_selector "h1", text: "Channel statuses"
  end

  test "should create channel status" do
    visit channel_statuses_url
    click_on "New channel status"

    fill_in "Channel", with: @channel_status.channel_id
    fill_in "Status", with: @channel_status.status_id
    click_on "Create Channel status"

    assert_text "Channel status was successfully created"
    click_on "Back"
  end

  test "should update Channel status" do
    visit channel_status_url(@channel_status)
    click_on "Edit this channel status", match: :first

    fill_in "Channel", with: @channel_status.channel_id
    fill_in "Status", with: @channel_status.status_id
    click_on "Update Channel status"

    assert_text "Channel status was successfully updated"
    click_on "Back"
  end

  test "should destroy Channel status" do
    visit channel_status_url(@channel_status)
    click_on "Destroy this channel status", match: :first

    assert_text "Channel status was successfully destroyed"
  end
end

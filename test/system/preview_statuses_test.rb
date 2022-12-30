require "application_system_test_case"

class PreviewStatusesTest < ApplicationSystemTestCase
  setup do
    @preview_status = preview_statuses(:one)
  end

  test "visiting the index" do
    visit preview_statuses_url
    assert_selector "h1", text: "Preview statuses"
  end

  test "should create preview status" do
    visit preview_statuses_url
    click_on "New preview status"

    fill_in "Channel", with: @preview_status.channel_id
    fill_in "Preview", with: @preview_status.preview_id
    fill_in "Valid until", with: @preview_status.valid_until
    click_on "Create Preview status"

    assert_text "Preview status was successfully created"
    click_on "Back"
  end

  test "should update Preview status" do
    visit preview_status_url(@preview_status)
    click_on "Edit this preview status", match: :first

    fill_in "Channel", with: @preview_status.channel_id
    fill_in "Preview", with: @preview_status.preview_id
    fill_in "Valid until", with: @preview_status.valid_until
    click_on "Update Preview status"

    assert_text "Preview status was successfully updated"
    click_on "Back"
  end

  test "should destroy Preview status" do
    visit preview_status_url(@preview_status)
    click_on "Destroy this preview status", match: :first

    assert_text "Preview status was successfully destroyed"
  end
end

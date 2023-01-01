require "application_system_test_case"

class ChannelGamesTest < ApplicationSystemTestCase
  setup do
    @channel_game = channel_games(:one)
  end

  test "visiting the index" do
    visit channel_games_url
    assert_selector "h1", text: "Channel games"
  end

  test "should create channel game" do
    visit channel_games_url
    click_on "New channel game"

    fill_in "Channel", with: @channel_game.channel_id
    fill_in "Game", with: @channel_game.game_id
    click_on "Create Channel game"

    assert_text "Channel game was successfully created"
    click_on "Back"
  end

  test "should update Channel game" do
    visit channel_game_url(@channel_game)
    click_on "Edit this channel game", match: :first

    fill_in "Channel", with: @channel_game.channel_id
    fill_in "Game", with: @channel_game.game_id
    click_on "Update Channel game"

    assert_text "Channel game was successfully updated"
    click_on "Back"
  end

  test "should destroy Channel game" do
    visit channel_game_url(@channel_game)
    click_on "Destroy this channel game", match: :first

    assert_text "Channel game was successfully destroyed"
  end
end

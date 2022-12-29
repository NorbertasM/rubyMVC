require "test_helper"

class ChannelGamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel_game = channel_games(:one)
  end

  test "should get index" do
    get channel_games_url
    assert_response :success
  end

  test "should get new" do
    get new_channel_game_url
    assert_response :success
  end

  test "should create channel_game" do
    assert_difference("ChannelGame.count") do
      post channel_games_url, params: { channel_game: { channel_id: @channel_game.channel_id, game_id: @channel_game.game_id } }
    end

    assert_redirected_to channel_game_url(ChannelGame.last)
  end

  test "should show channel_game" do
    get channel_game_url(@channel_game)
    assert_response :success
  end

  test "should get edit" do
    get edit_channel_game_url(@channel_game)
    assert_response :success
  end

  test "should update channel_game" do
    patch channel_game_url(@channel_game), params: { channel_game: { channel_id: @channel_game.channel_id, game_id: @channel_game.game_id } }
    assert_redirected_to channel_game_url(@channel_game)
  end

  test "should destroy channel_game" do
    assert_difference("ChannelGame.count", -1) do
      delete channel_game_url(@channel_game)
    end

    assert_redirected_to channel_games_url
  end
end

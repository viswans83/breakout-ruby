require "gosu"

require "breakout/version"
require "breakout/constants"
require "breakout/window"
require "breakout/assets"
require "breakout/game"
require "breakout/factory"

module Breakout
  def self.play
    game_window = GameWindow.new 640, 480, "Breakout!"
    game_assets = Assets.new game_window
    game_factory = Factory.new game_window, game_assets

    game = game_factory.make_new_game "basic"
    game_window.game = game
    game_window.on_game_over do
      game_window.game = game_factory.make_new_game "basic"
    end

    game_window.show
  end
end

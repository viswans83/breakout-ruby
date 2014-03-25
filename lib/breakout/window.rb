module Breakout
  class GameWindow < Gosu::Window
    attr_accessor :mx, :my, :old_mx, :old_my
    attr_accessor :game
    attr_accessor :game_over_action

    def initialize width, height, caption
      super width, height, false
      self.caption = caption
    end
    
    def update
      update_input
      update_game

      handle_game_over if game_over?
    end

    def draw
      game.draw
    end
    
    def update_input
      self.old_mx, self.old_my = mx || mouse_x, my || mouse_y
      self.mx, self.my = mouse_x, mouse_y

      input_handler.mouse_x = mx
      input_handler.mouse_y = my

      input_handler.mouse_x_delta = mx - old_mx
      input_handler.mouse_y_delta = my - old_my
    end

    def update_game
      game.update
    end

    def input_handler
      game.input_handler
    end
    
    def button_down key
      case key
      when Gosu::KbEscape
        close
      else
        input_handler.key_down key
      end
    end

    def game_over?
      game.game_over?
    end

    def on_game_over &proc
      self.game_over_action = proc
    end

    def handle_game_over
      game_over_action.call
    end
  end
end

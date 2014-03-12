require "gosu"

require "breakout/version"
require "breakout/entity"
require "breakout/aabb"
require "breakout/paddle"
require "breakout/ball"
require "breakout/wall"
require "breakout/collider"

module Breakout
  class ZOrder
    Back,Normal,Front,Ball = 0,1,2,3
  end
  
  class GameWindow < Gosu::Window
    private

    attr_reader :paddle, :ball, :wall, :collider
    attr_accessor :mx, :my, :old_mx, :old_my

    def initialize
      super 640, 480, false

      @caption = "Breakout!"
      @mx, @my = 0, 0

      @paddle = Paddle.new(self)
      @ball = Ball.new(self)
      @wall = Wall.new(self)
      @collider = Collider.new wall: wall,
                               paddle: paddle,
                               ball: ball

      ball.vx = 300
      ball.vy = -300
    end
        
    def update
      exit if escape_pressed?

      update_mouse

      paddle.move_by mouse_x_delta
      collider.do_collisions delta_t
      ball.move delta_t
    end

    def draw
      paddle.draw
      ball.draw
    end

    def update_mouse
      self.old_mx, self.old_my = mx, my
      self.mx, self.my = mouse_x, mouse_y
    end
    
    def mouse_x_delta
      mx - old_mx
    end

    def delta_t
      1.fdiv 60
    end

    def escape_pressed?
      button_down? Gosu::KbEscape
    end

    def exit
      close
    end
  end

  def self.play
    window = GameWindow.new
    window.show
  end
end

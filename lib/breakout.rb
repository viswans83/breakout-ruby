require "gosu"

require "breakout/version"
require "breakout/entity"
require "breakout/aabb"
require "breakout/paddle"
require "breakout/ball"
require "breakout/wall"
require "breakout/event"
require "breakout/collider"
require "breakout/sound"

module Breakout
  FRAME_RATE = 60
  FRAME_DELTA_T = 1.fdiv FRAME_RATE
  
  class ZOrder
    Back,Normal,Front,Ball = 0,1,2,3
  end

  class GameWindow < Gosu::Window
    private
    attr_accessor :paused
    attr_reader :event_queue
    attr_reader :sound_lib
    attr_reader :paddle, :ball, :wall, :collider
    attr_accessor :mx, :my, :old_mx, :old_my

    def initialize
      super 640, 480, false

      @caption = "Breakout!"
      @mx, @my = 0, 0
      
      @event_queue = EventQueue.new
      @sound_lib = SoundLib.new(self)
      
      @paddle = Paddle.new(self)
      @ball = Ball.new(self)
      @wall = Wall.new(self)
      @collider = Collider.new wall: wall,
                               paddle: paddle,
                               ball: ball,
                               event_queue: event_queue
      init_game
    end

    def init_game
      self.paused = true
      
      ball.center_at x: width/2, y: height/2
      paddle.center_at x: width/2, y: height/2

      direction = (rand * 100).to_i.even? ? 1 : -1
      ball.init_velocity vx: (300 + (rand * 100)) * direction,
                         vy: -300
    end
        
    alias_method :reset_game, :init_game

    def update
      update_mouse

      if not paused
        paddle.move_by mouse_x_delta
        collider.do_collisions delta_t
        ball.move delta_t

        case event_queue.next_event
        when :collision then sound_lib.random_bouncing_sound.play
        when :game_over then reset_game
        end
      end
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
      FRAME_DELTA_T
    end

    def button_down id
      case id
      when Gosu::KbSpace then toggle_pause
      when Gosu::KbEscape then exit_game
      end
    end

    def toggle_pause
      self.paused = !paused
    end

    def exit_game
      close
    end
  end

  def self.play
    window = GameWindow.new
    window.show
  end
end

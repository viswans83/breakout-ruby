require "gosu"

require "breakout/version"
require "breakout/assets"
require "breakout/entity"
require "breakout/aabb"
require "breakout/paddle"
require "breakout/ball"
require "breakout/wall"
require "breakout/brick"
require "breakout/level"
require "breakout/event"
require "breakout/collider"

module Breakout
  FRAME_RATE = 60
  FRAME_DELTA_T = 1.fdiv FRAME_RATE
  
  class ZOrder
    Back,Normal,Front,Ball = 0,1,2,3
  end

  class GameWindow < Gosu::Window
    private
    attr_accessor :paused, :game_started
    attr_accessor :level_progress
    attr_accessor :paddle, :ball, :wall, :bricks
    attr_accessor :collider, :event_queue
    attr_accessor :mx, :my, :old_mx, :old_my

    def initialize
      super 640, 480, false
      
      Assets.load self
      
      @caption = "Breakout!"
      @mx, @my = 0, 0
      
      @event_queue = EventQueue.new
      
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
      self.game_started = false
      self.bricks = Level.load("levels/basic.yaml").bricks
      self.level_progress = LevelProgress.new bricks.size

      collider.bricks = bricks
      
      bricks.define_singleton_method(:draw) do
        each { |brick| brick.draw if not brick.destroyed? }
      end
      
      paddle.center_at x: width/2
      ball.center_at x: paddle.center[:x],
                     y: (paddle.y - ball.height/2)

      direction = (rand * 100).to_i.even? ? 1 : -1
      ball.init_velocity vx: (300 + (rand * 100)) * direction,
                         vy: -300
    end
        
    alias_method :reset_game, :init_game

    def update
      update_mouse

      unless game_started
        paddle.move_by mouse_x_delta
        ball.center_at x: paddle.center[:x]
      end
      
      unless paused
        paddle.move_by mouse_x_delta
        collider.do_collisions delta_t
        ball.move delta_t

        until event_queue.empty? do
          event = event_queue.next_event
          event_type = event[:type]

          case event_type
          when :collision
            collision_with = event[:with]
            case collision_with
            when :paddle, :wall, :brick
              Assets.sound(Assets::BOUNCE_SOUNDS.sample).play
            when :floor
              reset_game
            end
            level_progress.brick_down if collision_with == :brick
          else
            puts "Unknown event type: #{event_type}"
          end
        end

        reset_game if level_progress.level_complete?
      end
    end

    def draw
      paddle.draw
      ball.draw
      bricks.draw
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
      when Gosu::MsLeft, Gosu::KbSpace
        start_game unless game_started
        toggle_pause if game_started
      when Gosu::KbEscape
        exit_game
      end
    end

    def start_game
      self.game_started = true
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

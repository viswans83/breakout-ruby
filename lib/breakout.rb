require "gosu"

require "breakout/version"
require "breakout/constants"
require "breakout/input"
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
  class GameWindow < Gosu::Window
    private
    attr_reader :input
    attr_accessor :game_paused, :game_in_progress
    attr_accessor :level_progress
    attr_accessor :paddle, :ball, :wall, :bricks
    attr_accessor :collider, :event_queue

    def initialize
      super 640, 480, false
      
      Assets.load self
      
      @caption = "Breakout!"

      @input = Input.new
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
      self.game_paused = true
      self.game_in_progress = false
      self.bricks = Level.load("levels/basic.yaml").bricks
      self.level_progress = LevelProgress.new(bricks.size)

      level_progress.on_level_complete do
        level_complete
      end

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
      update_and_handle_input

      unless game_in_progress
        paddle.move_by input.mouse_x_delta
        ball.center_at x: paddle.center[:x]
      end
      
      unless game_paused
        paddle.move_by input.mouse_x_delta
        collider.do_collisions input.delta_t
        ball.move input.delta_t
        process_game_events
      end
    end

    def draw
      paddle.draw
      ball.draw
      bricks.draw
    end

    def process_game_events
      until event_queue.empty? do
        event = event_queue.next_event
        event_type = event[:type]

        case event_type
        when :collision then handle_collisions(event[:with])
        end
      end
    end

    def handle_collisions object
      case object
      when :brick
        play_sound
        clear_brick
      when :paddle, :wall
        play_sound
      when :floor
        reset_game
      end
    end

    def play_sound
      Assets.sound(Assets::BOUNCE_SOUNDS.sample).play
    end

    def clear_brick
      level_progress.brick_down
    end

    def level_complete
      reset_game
    end
    
    def update_and_handle_input
      input.update(self)
      case 
      when input.space_pressed?, input.mouse_clicked?
        start_game unless game_in_progress
        toggle_game_paused if game_in_progress
      when input.escape_pressed?
        exit_game
      end
    end

    def start_game
      self.game_in_progress = true
    end

    def toggle_game_paused
      self.game_paused = !game_paused
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

require "gosu"

require "breakout/version"
require "breakout/constants"
require "breakout/assets"
require "breakout/entity"
require "breakout/game_objects"
require "breakout/level"
require "breakout/event"
require "breakout/collider"

module Breakout
  class GameWindow < Gosu::Window
    private
    attr_accessor :game_paused, :game_in_progress
    attr_accessor :level_progress
    attr_accessor :paddle, :ball, :wall, :bricks
    attr_accessor :collider, :event_queue
    attr_accessor :mx, :my, :old_mx, :old_my

    def initialize
      super 640, 480, false
      @caption = "Breakout!"

      Assets.load self      
      init_game      
    end

    def init_game
      self.game_paused = true
      self.game_in_progress = false

      self.event_queue = EventQueue.new

      self.paddle = Paddle.new
      paddle.set_image Assets.image(:paddle)
      paddle.set_size_from_image
      paddle.set_z_order ZOrder::Normal
      paddle.center_at x: width/2,
                       y: height - paddle.height
      paddle.set_bounds min_x: 0,
                        max_x: width - paddle.width
      paddle.mouse_velocity = 0
      
      self.ball = Ball.new
      ball_direction = (rand * 100).to_i.even? ? 1 : -1
      ball.set_image Assets.image(:ball)
      ball.set_size_from_image
      ball.set_z_order ZOrder::Ball
      ball.center_at x: paddle.center[:x],
                     y: (paddle.y - ball.height/2)
      ball.set_velocity vx: (300 + (rand * 100)) * ball_direction,
                        vy: -300
      
      self.wall = Wall.new
      wall.set_position x: 0,
                        y: 0
      wall.set_size width: width,
                    height: height
      
      self.bricks = Level.load("levels/basic.yaml").bricks.map do |brick_def|
        Brick.new.tap do |brick|
          image_key = "brick_#{brick_def[:color]}".to_sym
          brick.set_image Assets.image(image_key)
          brick.set_size_from_image
          brick.set_z_order ZOrder::Normal
          brick.set_position x: brick_def[:x],
                             y: brick_def[:y]
        end
      end
      bricks.define_singleton_method(:draw) do
        each { |brick| brick.draw if not brick.destroyed? }
      end
      
      self.level_progress = LevelProgress.new(bricks.size)
      level_progress.on_level_complete do
        reset_game
      end
      
      self.collider = Collider.new wall: wall,
                                   paddle: paddle,
                                   bricks: bricks,
                                   ball: ball,
                                   event_queue: event_queue
    end
        
    alias_method :reset_game, :init_game

    def update
      update_mouse

      unless game_in_progress
        paddle.move_by delta_x: mouse_x_delta
        ball.center_at x: paddle.center[:x]
      end
      
      unless game_paused
        paddle.move_by delta_x: mouse_x_delta

        collider.collide_ball_paddle delta_t, mouse_x_velocity
        collider.collide_ball_wall delta_t
        collider.collide_ball_bricks delta_t

        ball.move delta_t
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
    
    def update_mouse
      self.old_mx, self.old_my = mx || mouse_x, my || mouse_y
      self.mx, self.my = mouse_x, mouse_y
    end
    
    def mouse_x_delta
      mx - old_mx
    end

    def mouse_x_velocity
      mouse_x_delta.fdiv FRAME_DELTA_T
    end

    def delta_t
      FRAME_DELTA_T
    end

    def button_down id
      case id
      when Gosu::MsLeft, Gosu::KbSpace
        start_game unless game_in_progress
        toggle_game_paused if game_in_progress
      when Gosu::KbEscape
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

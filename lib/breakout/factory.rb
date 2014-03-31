require "breakout/constants"
require "breakout/game"
require "breakout/entity"
require "breakout/objects"
require "breakout/level"
require "breakout/event"
require "breakout/collider"
require "breakout/input"
require "breakout/clock"

module Breakout
  class GameFactory
    attr_reader :window, :assets
    
    def initialize window, assets
      @window = window
      @assets = assets
    end
    
    def make_new_game level
      Game.new.tap do |game|

        event_queue = EventQueue.new

        paddle = Paddle.new
        paddle.set_image assets.image(:paddle)
        paddle.set_size_from_image
        paddle.set_z_order ZOrder::NORMAL
        paddle.center_at x: window.width / 2,
                         y: window.height - paddle.height
        paddle.set_bounds min_x: 0,
                          max_x: window.width - paddle.width

        ball = Ball.new
        ball_direction = (rand * 100).to_i.even? ? 1 : -1
        ball.set_image assets.image(:ball)
        ball.set_size_from_image
        ball.set_z_order ZOrder::BALL
        ball.center_at x: paddle.center[:x],
                       y: (paddle.y - ball.height/2)
        ball.set_velocity vx: (300 + (rand * 100)) * ball_direction,
                          vy: -300

        wall = Wall.new
        wall.set_position x: 0,
                          y: 0
        wall.set_size width: window.width,
                      height: window.height

        bricks = Level.load("levels/#{level}.yaml").bricks.map do |brick_def|
          Brick.new.tap do |brick|
            image_key = "brick_#{brick_def[:color]}".to_sym
            brick.set_image assets.image(image_key)
            brick.set_size_from_image
            brick.set_z_order ZOrder::NORMAL
            brick.set_position x: brick_def[:x],
                               y: brick_def[:y]
          end
        end
                
        level_progress = LevelProgress.new(bricks.size)
        level_progress.on_level_complete do
          game.end_game
        end

        clock = Clock.new FRAME_DELTA_T
                
        collider = Collider.new wall: wall,
                                paddle: paddle,
                                bricks: bricks,
                                ball: ball,
                                event_queue: event_queue
        
        input_handler = Input.new
        input_handler.on_key_down do |key|
          case key
          when Gosu::MsLeft, Gosu::KbSpace
            game.start_game unless game.game_in_progress
            game.toggle_game_paused if game.game_in_progress
          end
        end

        sound_box = SoundBox.new assets

        game.paddle = paddle
        game.ball = ball
        game.wall = wall
        game.bricks = bricks
        game.collider = collider
        game.event_queue = event_queue
        game.level_progress = level_progress
        game.clock = clock
        game.input_handler = input_handler
        game.sound_box = sound_box
      end
    end
  end
end

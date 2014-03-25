module Breakout
  class Game
    attr_accessor :assets
    attr_accessor :game_paused, :game_in_progress, :game_over
    attr_accessor :paddle, :ball, :wall, :bricks
    attr_accessor :collider, :event_queue, :level_progress
    attr_accessor :clock, :input_handler

    alias_method :game_paused?, :game_paused
    alias_method :game_in_progress?, :game_in_progress
    alias_method :game_over?, :game_over
    
    def initialize
      self.game_in_progress = false
      self.game_paused = true
      self.game_over = false
    end
    
    def update
      unless game_in_progress?
        paddle.move_by delta_x: mouse_x_delta
        ball.center_at x: paddle.center[:x]
      end
      
      unless game_paused?
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
        end_game
      end
    end

    def play_sound
      assets.sound(Assets::BOUNCE_SOUNDS.sample).play
    end

    def clear_brick
      level_progress.brick_down
    end
    
    def mouse_x_delta
      input_handler.mouse_x_delta
    end

    def mouse_x_velocity
      mouse_x_delta.fdiv delta_t
    end

    def delta_t
      clock.delta_t
    end

    def start_game
      self.game_in_progress = true
    end

    def toggle_game_paused
      self.game_paused = !game_paused?
    end

    def end_game
      self.game_over = true
    end
  end
end

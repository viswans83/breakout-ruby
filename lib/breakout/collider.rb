module Breakout
  class Collider
    def initialize objects
      @wall = objects[:wall]
      @paddle = objects[:paddle]
      @ball = objects[:ball]
      @event_queue = objects[:event_queue]
    end

    def do_collisions delta_t
      collide_ball_paddle delta_t
      collide_ball_wall delta_t
    end

    private
    attr_reader :wall, :paddle, :ball
    attr_reader :event_queue

    def collide_ball_paddle delta_t
      if (ball.moving_down? and
          ball.down_after(delta_t) > paddle.up and
          ball.down_after(delta_t) < paddle.down and
          ball.left_after(delta_t) > paddle.left and
          ball.right_after(delta_t) < paddle.right)
        ball.bounce_y
        event_queue.add_event :collision
      end
    end

    def collide_ball_wall delta_t
      if ball.moving_left? and ball.left_after(delta_t) < wall.left
        ball.bounce_x
        event_queue.add_event :collision
      end
      if ball.moving_right? and ball.right_after(delta_t) > wall.right
        ball.bounce_x
        event_queue.add_event :collision
      end
      if ball.moving_up? and ball.up_after(delta_t) < wall.up
        ball.bounce_y
        event_queue.add_event :collision
      end
      if ball.moving_down? and ball.down_after(delta_t) > wall.down
        ball.bounce_y
        event_queue.add_event :collision
      end
    end
  end
end

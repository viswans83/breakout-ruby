module Breakout
  class Collider
    attr_accessor :bricks
    
    def initialize objects
      @wall = objects[:wall]
      @paddle = objects[:paddle]
      @ball = objects[:ball]
      @event_queue = objects[:event_queue]
    end

    def do_collisions delta_t
      collide_ball_paddle delta_t
      collide_ball_wall delta_t
      collide_ball_bricks delta_t
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
        ball.vx -= paddle.velocity * 0.25
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
        event_queue.add_event :game_over
      end
    end

    def collide_ball_bricks delta_t
      alive_bricks = bricks.select {|b| not b.destroyed?}
      alive_bricks.each do |brick|
        if (ball.moving_left? and
            ball.left > brick.right and
            ball.left_after(delta_t) <= brick.right and
            [ball.up_after(delta_t), ball.down_after(delta_t)].any? {|v| v.between? brick.up, brick.down})
          brick.destroy
          ball.bounce_x
          event_queue.add_event :collision
        end
        if (ball.moving_right? and
            ball.right < brick.left and
            ball.right_after(delta_t) >= brick.left and
            [ball.up_after(delta_t), ball.down_after(delta_t)].any? {|v| v.between? brick.up, brick.down})
          brick.destroy
          ball.bounce_x
          event_queue.add_event :collision
        end
        if (ball.moving_up? and
            ball.up > brick.down and
            ball.up_after(delta_t) <= brick.down and
            [ball.left_after(delta_t), ball.right_after(delta_t)].any? {|v| v.between? brick.left, brick.right})
          brick.destroy
          ball.bounce_y
          event_queue.add_event :collision
        end
        if (ball.moving_down? and
            ball.down < brick.up and
            ball.down_after(delta_t) >= brick.up and
            [ball.left_after(delta_t), ball.right_after(delta_t)].any? {|v| v.between? brick.left, brick.right})
          brick.destroy
          ball.bounce_y
          event_queue.add_event :collision
        end
      end
      event_queue.add_event :level_complete if bricks.select {|b| not b.destroyed?}.empty?
    end
  end
end

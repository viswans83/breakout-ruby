require "gosu"
require "breakout/version"

module Breakout

  class ZOrder
    Back,Normal,Front,Ball = 0,1,2,3
  end

  class Window < Gosu::Window
    private

    attr_reader :delta_t
    attr_reader :paddle, :ball, :walls, :collider
    attr_accessor :mx, :my, :old_mx, :old_my

    def initialize
      super 640, 480, false
      self.caption = "Breakout!"

      @delta_t = fps.fdiv 1000
      @mx, @my = 0, 0
      
      @paddle = Paddle.new(self)
      @ball = Ball.new(self)
      @walls = Walls.new(self)
      @collider = Collider.new walls: walls,
                               paddle: paddle,
                               ball: ball

      ball.vx = 300
      ball.vy = -300
    end
        
    def update
      exit if button_down? Gosu::KbEscape

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

    def exit
      close
    end
  end

  module AABB
    attr_accessor :height, :width

    def center_x; (left + right).fdiv_2; end
    def center_y; (up + down).fdiv_2; end    
    def up; y; end
    def down; y + height; end
    def left; x; end
    def right; x + width; end
  end

  module ImageAABB
    include AABB

    def height; image.height; end
    def width; image.width; end

    private

    attr_accessor :image
  end

  module HasPosition
    attr_accessor :x, :y
  end
  
  module HasVelocity
    attr_accessor :vx, :vy

    def moving_right?
      vx > 0
    end

    def moving_left?
      vx < 0
    end

    def moving_down?
      vy >  0
    end

    def moving_up?
      vy < 0
    end

    def x_after delta_t
      x + (vx * delta_t)
    end

    def y_after delta_t
      y + (vy * delta_t)
    end

    def bounce_x
      self.vx *= -1
    end

    def bounce_y
      self.vy *= -1
    end
    
    def move delta_t
      self.x = x_after delta_t
      self.y = y_after delta_t
    end
  end

  module AABBWithVelocity
    def up_after delta_t
      up + (vy * delta_t)
    end

    def down_after delta_t
      down + (vy * delta_t)
    end

    def left_after delta_t
      left + (vx * delta_t)
    end

    def right_after delta_t
      right + (vx * delta_t)
    end
  end

  class Walls
    include HasPosition
    include AABB
        
    def initialize window
      @x, @y = 0, 0
      @height = window.height
      @width = window.width
    end

    private

    attr_reader :width, :height
  end

  class Paddle
    include HasPosition
    include ImageAABB

    def initialize window
      @image = Gosu::Image.new(window, "png/paddleBlu.png", false)
      @max_x = window.width - image.width
      @min_x = 0
      @x = (window.width - image.width) / 2
      @y = (window.height - (image.height * 2))
    end

    def draw
      image.draw(x,y,ZOrder::Normal)
    end

    def move_by delta_x
      new_x = x + delta_x
      self.x = case
               when new_x > max_x then max_x
               when new_x < min_x then min_x
               else new_x
               end
    end

    private

    attr_reader :min_x, :max_x
  end

  class Ball
    include HasPosition
    include HasVelocity
    include ImageAABB
    include AABBWithVelocity

    def initialize window
      @x = window.width / 2
      @y = window.height / 2
      @image = Gosu::Image.new(window, "png/ballBlue.png", false)
    end
    
    def draw
      image.draw(x,y,ZOrder::Front)
    end
    
  end

  class Collider
    def initialize objects
      @walls = objects[:walls]
      @paddle = objects[:paddle]
      @ball = objects[:ball]
    end

    def do_collisions delta_t
      collide_ball_paddle delta_t
      collide_ball_walls delta_t
    end

    private

    attr_reader :walls, :paddle, :ball

    def collide_ball_paddle delta_t
      if (ball.moving_down? and
          ball.down_after(delta_t) > paddle.up and
          ball.left_after(delta_t) > paddle.left and
          ball.right_after(delta_t) < paddle.right)
        ball.bounce_y
      end
    end

    def collide_ball_walls delta_t
      if ball.moving_left? and ball.left_after(delta_t) < walls.left
        ball.bounce_x
      end
      if ball.moving_right? and ball.right_after(delta_t) > walls.right
        ball.bounce_x
      end
      if ball.moving_up? and ball.up_after(delta_t) < walls.up
        ball.bounce_y
      end
      if ball.moving_down? and ball.down_after(delta_t) > walls.down
        ball.bounce_y
      end
    end
  end

  def self.play
    window = Window.new
    window.show
  end
end

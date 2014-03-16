module Breakout
  module HasPosition
    attr_accessor :x, :y

    def init_position p
      @x, @y = p[:x], p[:y]
    end
  end

  module HasVelocity
    attr_accessor :vx, :vy

    def init_velocity v
      @vx, @vy = v[:vx], v[:vy]
    end

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
end

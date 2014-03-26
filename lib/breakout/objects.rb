module Breakout
  class Wall < GameObject; end
  class Ball < GameObject; end
  class Paddle < GameObject; end

  class Brick < GameObject
    attr_accessor :destroyed
    attr_accessor :visible
    alias_method :destroyed?, :destroyed
    alias_method :visible?, :visible

    def initialize
      self.visible = true
    end
    
    def destroy ball_velocity
      self.destroyed = true
      self.ttl = self.total_ttl = 0.5
      set_rotation(0)
      set_scale(1)
      set_angular_velocity(ball_velocity * 1.5)
    end

    def step_animation delta_t
      self.ttl = ttl - delta_t
      set_mask Gosu::Color.rgba(255,255,255,alpha_value)
      set_scale visibility
      rotate delta_t

      dissappear if ttl < 0
    end

    def dissappear
      self.visible = false
    end

    private
    attr_accessor :ttl, :total_ttl

    def alpha_value
      (255 * visibility).to_i
    end

    def visibility
      ttl.fdiv(total_ttl)
    end
  end
end

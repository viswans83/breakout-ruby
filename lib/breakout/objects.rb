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
      @visible = true
    end
    
    def destroy
      @destroyed = true
      @ttl = @total_ttl = 0.5
    end

    def visibility_factor
      destroyed ? ttl.fdiv(total_ttl) : 1
    end

    def step_animation delta_t
      if destroyed? and visible?
        self.ttl = ttl - delta_t
        dissappear if ttl < 0
      end
    end

    def dissappear
      self.visible = false
    end

    def draw
      alpha = (255 * visibility_factor).to_i
      color = Gosu::Color.rgba(255,255,255,alpha)
      image.draw(x,y,z_order,1,1,color)
    end

    private
    attr_accessor :ttl, :total_ttl
  end
end

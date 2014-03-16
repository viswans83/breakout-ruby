module Breakout
  module AABB
    attr_accessor :height, :width

    def init_aabb aabb
      @height, @width = aabb[:height], aabb[:width]
    end
    
    def up; y; end
    def down; y + height; end
    def left; x; end
    def right; x + width; end

    def center_at p
      self.x = p[:x] - width / 2
      self.y = p[:y] - height / 2
    end

    private :init_aabb
  end

  module ImageAABB
    include AABB

    def init_image_aabb image
      @image = image
      init_aabb height: image.height,
                width: image.width      
    end

    private

    attr_reader :image
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
end

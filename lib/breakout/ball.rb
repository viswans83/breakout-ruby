module Breakout
  class Ball
    include HasPosition
    include HasVelocity
    include ImageAABB
    include AABBWithVelocity

    def initialize window
      init_position x: window.width / 2,
                    y: window.height / 2
      init_velocity vx: 0,
                    vy: 0
      init_image_aabb Assets.image(:ball)
    end
    
    def draw
      image.draw(x,y,ZOrder::Ball)
    end
  end
end

module Breakout
  class Paddle
    include HasPosition
    include ImageAABB

    attr_accessor :velocity

    def initialize window
      init_image_aabb Assets.image(:paddle)
      init_position x: (window.width - image.width) / 2,
                    y: window.height - (image.height * 2)

      @min_x, @max_x = 0, window.width - width
    end

    def draw
      image.draw(x,y,ZOrder::Normal)
    end

    def move_by delta_x
      new_x = x + delta_x
      
      self.velocity = delta_x.fdiv FRAME_DELTA_T
      self.x = case
               when new_x > max_x then max_x
               when new_x < min_x then min_x
               else new_x
               end
    end

    private
    attr_reader :min_x, :max_x
  end
end

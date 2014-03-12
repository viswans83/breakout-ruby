module Breakout
  class Paddle
    include HasPosition
    include ImageAABB

    def initialize window
      init_image_aabb Gosu::Image.new(window, "png/paddleBlu.png", false)
      init_position x: (window.width - image.width) / 2,
                    y: window.height - (image.height * 2)

      @max_x = window.width - width
      @min_x = 0
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
end

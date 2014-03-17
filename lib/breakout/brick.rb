module Breakout
  class Brick
    include HasPosition
    include ImageAABB

    attr_accessor :velocity

    def initialize window
      init_image_aabb Gosu::Image.new(window, "png/element_green_rectangle.png", false)
      init_position x: (window.width - image.width) / 2,
                    y: window.height - (image.height * 2)

      @min_x, @max_x = 0, window.width - width
    end

    def draw
      image.draw(x,y,ZOrder::Normal)
    end

    private
    attr_reader :min_x, :max_x
  end
end

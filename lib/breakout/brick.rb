module Breakout
  class Brick
    include HasPosition
    include AABB

    attr_reader :color
    
    def initialize brick_def
      init_position x: brick_def[:x],
                    y: brick_def[:y]
      init_aabb width: 64, height: 32

      @color = brick_def[:color]
    end

    def destroyed?
      @destroyed
    end

    def destory
      @destroyed = true
    end

    def draw
      Assets.image(image_asset_key).draw(x,y,ZOrder::Normal)
    end

    private
    def image_asset_key
      @image_sym ||= "brick_#{color}".to_sym
    end
  end
end

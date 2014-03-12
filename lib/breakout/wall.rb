module Breakout
  class Wall
    include HasPosition
    include AABB
    
    def initialize window
      init_position x: 0,
                    y: 0
      init_aabb width: window.width,
                height: window.height
    end
  end
end

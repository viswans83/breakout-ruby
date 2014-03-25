module Breakout
  class Wall < GameObject; end
  class Ball < GameObject; end
  class Paddle < GameObject; end

  class Brick < GameObject
    attr_accessor :destroyed
    alias_method :destroyed?, :destroyed
    
    def destroy
      @destroyed = true
    end
  end
end

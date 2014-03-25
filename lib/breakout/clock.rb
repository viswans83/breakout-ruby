module Breakout
  class Clock
    attr_reader :delta_t
    def initialize delta_t
      @delta_t = delta_t
    end
  end
end

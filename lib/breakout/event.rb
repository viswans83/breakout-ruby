module Breakout
  class EventQueue
    def initialize
      @data = Array.new
    end

    def add_event ev
      data.unshift(ev)
    end

    def next_event
      data.pop
    end

    private
    attr_reader :data
  end
end

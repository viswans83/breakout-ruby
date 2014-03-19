require 'yaml'

module Breakout
  class Level
    attr_reader :bricks
    
    def initialize level_def
      @bricks = level_def.map do |brick_def|
        Brick.new brick_def
      end
    end
      
    def self.load path
      new YAML.load(IO.read path)
    end
  end

  class LevelProgress
    attr_accessor :bricks_remaining

    def initialize brick_count
      @bricks_remaining = brick_count
    end

    def brick_down
      self.bricks_remaining -= 1
    end

    def level_complete?
      bricks_remaining == 0
    end
  end
end

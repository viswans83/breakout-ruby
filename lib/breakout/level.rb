require 'yaml'

module Breakout
  class Level
    attr_reader :bricks
    
    def initialize bricks
      @bricks = bricks
    end
      
    def self.load path
      new YAML.load(IO.read path)
    end
  end

  class LevelProgress
    attr_reader :score
    
    def initialize brick_count, &level_complete_action
      @score = 0
      @bricks_remaining = brick_count
      @level_complete_action = level_complete_action
    end

    def on_level_complete &level_complete_action
      @level_complete_action = level_complete_action
    end

    def brick_down
      self.score = score + 1
      self.bricks_remaining = bricks_remaining - 1
      level_complete_action.call if level_complete_action && level_complete?
    end

    def level_complete?
      bricks_remaining == 0
    end

    private
    attr_writer :score
    attr_accessor :bricks_remaining
    attr_reader :level_complete_action
  end
end

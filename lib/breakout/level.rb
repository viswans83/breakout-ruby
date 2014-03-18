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
end

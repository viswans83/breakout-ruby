module Breakout
  class Input
    attr_accessor :mouse_x, :mouse_y
    attr_accessor :mouse_x_delta, :mouse_y_delta
    attr_accessor :key_down_action, :key_up_action
    
    def on_key_down &proc
      self.key_down_action = proc
    end

    def on_key_up &proc
      self.key_up_action = proc
    end

    def key_down key
      key_down_action.call key if key_down_action
    end

    def key_up key
      key_up_action.call key if key_up_action
    end
  end
end

module Breakout
  class Input
    attr_reader :mouse_clicked
    attr_reader :mouse_x, :mouse_y
    attr_reader :mouse_x_delta, :mouse_y_delta
    alias_method :mouse_clicked?, :mouse_clicked
    
    def initialize
      @keys = Hash.new
    end

    def update window
      update_keys window
      update_mouse window
    end

    def escape_pressed?
      keys[:escape]
    end

    def space_pressed?
      keys[:space]
    end

    def mouse_x_velocity
      mouse_x_delta / delta_t
    end

    def mouse_y_velocity
      mouse_y_delta / delta_t
    end
    
    def mouse_velocity
      {vx: mouse_x_velocity, vy: mouse_y_velocity}
    end

    def delta_t
      FRAME_DELTA_T
    end

    private
    attr_accessor :keys
    attr_writer :mouse_clicked
    attr_writer :mouse_x, :mouse_y
    attr_writer :mouse_x_delta, :mouse_y_delta
    attr_accessor :old_mouse_x, :old_mouse_y
    
    def update_keys window
      keys[:escape] = window.button_down? Gosu::KbEscape
      keys[:space] = window.button_down? Gosu::KbSpace
    end

    def update_mouse window
      self.mouse_clicked = window.button_down? Gosu::MsLeft
      self.old_mouse_x, self.old_mouse_y = mouse_x, mouse_y
      self.mouse_x, self.mouse_y = window.mouse_x, window.mouse_y

      self.mouse_x_delta = old_mouse_x ? mouse_x - old_mouse_x : 0
      self.mouse_y_delta = old_mouse_y ? mouse_y - old_mouse_y : 0
    end
  end
end

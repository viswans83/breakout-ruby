module Breakout
  module HasPosition
    attr_accessor :x, :y

    def set_position p
      self.x = p[:x]
      self.y = p[:y]
    end

    def move_by delta
      self.x = x + delta[:delta_x] if delta[:delta_x]
      self.y = y + delta[:delta_y] if delta[:delta_y]
    end
  end

  module HasRotation
    attr_accessor :angle

    def set_rotation angle
      self.angle = angle
    end

    def rotate_by delta
      self.angle = angle + delta
    end
  end

  module HasSize
    attr_accessor :height, :width

    def set_size size
      self.height = size[:height]
      self.width = size[:width]
    end
    
    def up; y; end
    def down; y + height; end
    def left; x; end
    def right; x + width; end

    def center
      {x: x + width/2, y: y + height/2}
    end

    def center_at p
      self.x = p[:x] - width / 2 if p[:x]
      self.y = p[:y] - height / 2 if p[:y]
    end
  end

  module HasVelocity
    attr_accessor :vx, :vy

    def set_velocity v
      self.vx = v[:vx]
      self.vy = v[:vy]
    end

    def velocity
      {
        vx: vx,
        vy: vy
      }
    end

    def scalar_velocity
      Math.sqrt(vx ** 2 + vy ** 2)
    end

    def moving_right?
      vx > 0
    end

    def moving_left?
      vx < 0
    end

    def moving_down?
      vy >  0
    end

    def moving_up?
      vy < 0
    end

    def x_after delta_t
      x + (vx * delta_t)
    end

    def y_after delta_t
      y + (vy * delta_t)
    end

    def bounce_x
      self.vx *= -1
    end

    def bounce_y
      self.vy *= -1
    end

    def up_after delta_t
      up + (vy * delta_t)
    end

    def down_after delta_t
      down + (vy * delta_t)
    end

    def left_after delta_t
      left + (vx * delta_t)
    end

    def right_after delta_t
      right + (vx * delta_t)
    end
    
    def move delta_t
      self.x = x_after delta_t
      self.y = y_after delta_t
    end
  end

  module HasAngularVelocity
    attr_accessor :angular_velocity

    def set_angular_velocity angular_velocity
      self.angular_velocity = angular_velocity
    end

    def rotate delta_t
      if angle
        self.angle = angle + (angular_velocity * delta_t)
        self.angle = self.angle - 360 if self.angle > 360
      end
    end
  end

  module Bounded
    attr_accessor :min_x, :max_x
    attr_accessor :min_y, :max_y

    def set_bounds bounds
      set_x_bounds bounds
      set_y_bounds bounds
    end

    def set_x_bounds x_bounds
      self.min_x = x_bounds[:min_x]
      self.max_x = x_bounds[:max_x]
    end

    def set_y_bounds y_bounds
      self.min_y = y_bounds[:min_y]
      self.max_y = y_bounds[:max_y]
    end

    def x= new_x
      super case
      when max_x && new_x > max_x then max_x
      when min_x && new_x < min_x then min_x
      else new_x
      end
    end

    def y= new_y
      super case
      when max_y && new_y > max_y then max_y
      when min_y && new_y < min_y then min_y
      else new_y
      end
    end
  end

  module Drawable
    attr_accessor :image
    attr_accessor :mask
    attr_accessor :scale
    attr_accessor :z_order

    def set_image image
      self.image = image
    end

    def set_z_order z_order
      self.z_order = z_order
    end

    def set_mask color
      self.mask = color
    end

    def set_scale scale
      self.scale = scale
    end

    def set_size_from_image
      set_size height: image.height,
               width: image.width
    end
    
    def draw
      if angle
        image.draw_rot(center[:x],center[:y],z_order,angle,0.5,0.5,scale || 1,scale || 1,mask || Gosu::Color::WHITE)
      else
        image.draw(x,y,z_order,scale || 1,scale || 1,mask || Gosu::Color::WHITE)
      end
    end
  end

  module HasAnimation
    def step_animation delta_t; end
  end

  class GameObject
    include HasPosition
    include HasRotation
    include HasSize
    include HasVelocity
    include HasAngularVelocity
    include Bounded
    include Drawable
    include HasAnimation
  end
end

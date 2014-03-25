module Breakout
  class Assets
    BRICK_COLORS = %w[blue green grey purple red yellow]
    BRICK_IMAGES = BRICK_COLORS.map { |c| ("brick_" + c).to_sym }
    BOUNCE_SOUNDS = %w[a4 b4 c4 d4 e4 f4 g4 a5].map { |n| n.to_sym }

    attr_reader :window, :images, :sounds
    def initialize window
      @window = window
      @images = Hash.new
      @sounds = Hash.new

      load_images
      load_sounds
    end

    def image sym
      images[sym]
    end

    def sound sym
      sounds[sym]
    end
    
    private
    
    def load_images
      images[:ball] = load_image "png/ballBlue.png"
      images[:paddle] = load_image "png/paddleRed.png"
      BRICK_COLORS.each do |color|
        key = "brick_" + color
        images[key.to_sym] = load_image "png/element_#{color}_rectangle.png"
      end
    end

    def load_image path
      Gosu::Image.new window, path, false
    end

    def load_sounds
      BOUNCE_SOUNDS.map do |note|
        sounds[note] = load_sound "snd/#{note}.wav"
      end
    end

    def load_sound path
      Gosu::Sample.new window, path
    end
  end
end

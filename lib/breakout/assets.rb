module Breakout
  class Assets
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
      %w[blue green grey purple red yellow].each do |color|
        key = "brick_#{color}".to_sym
        images[key] = load_image "png/element_#{color}_rectangle.png"
      end
    end

    def load_sounds
      %w[a4 b4 c4 d4 e4 f4 g4 a5].map do |note|
        key = "bounce_#{note}".to_sym
        sounds[key] = load_sound "snd/#{note}.wav"
      end
    end

    def load_image path
      Gosu::Image.new window, path, false
    end

    def load_sound path
      Gosu::Sample.new window, path
    end
  end

  class SoundBox
    attr_accessor :assets
    
    def initialize assets
      self.assets = assets
    end
    
    def play_sound key
      assets.sound(key).play
    end
  end
end

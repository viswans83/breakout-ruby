module Breakout
  class Assets
    BOUNCE_SOUNDS = %w[a4 b4 c4 d4 e4 f4 g4 a5].map {|n| n.to_sym}
    
    class << self
      attr_reader :images, :sounds

      def load window
        initialize
        load_images window
        load_sounds window
      end

      def random_bounce_sound
        sounds[BOUNCE_SOUNDS.sample]
      end

      private      
      def initialize
        @images = Hash.new
        @sounds = Hash.new
      end
      
      def load_images window
        images[:ball] = load_image window, "png/ballBlue.png"
        images[:paddle] = load_image window, "png/paddleRed.png"
        %w[blue green grey purple red].each do |color|
          key = "brick_" + color
          images[key.to_sym] = load_image window, "png/element_#{color}_rectangle.png"
        end
      end

      def load_image window, path
        Gosu::Image.new window, path, false
      end

      def load_sounds window
        BOUNCE_SOUNDS.map do |note|
          sounds[note] = load_sound window, "snd/#{note}.wav"
        end
      end

      def load_sound window, path
        Gosu::Sample.new window, path
      end
    end
  end
end

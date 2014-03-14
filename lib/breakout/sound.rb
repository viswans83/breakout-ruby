module Breakout
  class SoundLib
    def initialize window
      @bounce_samples = %w[a4 b4 c4 d4 e4 f4 g4 a5].map do |note|
        Gosu::Sample.new window, "snd/#{note}.wav"
      end
    end

    def random_bouncing_sound
      bounce_samples.sample
    end

    private
    attr_reader :bounce_samples
  end
end

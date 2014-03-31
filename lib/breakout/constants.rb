module Breakout
  FRAME_RATE = 60
  FRAME_DELTA_T = 1.fdiv FRAME_RATE
  
  BALL_BOUNCE_SOUND_KEYS = %w[a4 b4 c4 d4 e4 f4 g4 a5].map { |note| "bounce_#{note}".to_sym }
    
  class ZOrder
    NORMAL,BALL = 0,1
  end
end

class Camera2

  attr_accessor :position
  attr_reader :obj

  def initialize
    @position = Vector2.new 0, 0
    @dest_position = Vector2.new 0, 0
    @easer = Easer.new
    @countdown = Countdown.new(15)
    @view = Moon::Rect.new(-Moon::Screen.width/2, -Moon::Screen.height/2,
                            Moon::Screen.width/2,  Moon::Screen.height/2)
  end

  def follow(obj)
    @obj = obj
    @dest_position
  end

  def update
    if @obj
      a = @obj.position.xy * 32 + @view.xy
      if @dest_position != a
        @dest_position.set(*a)
        @countdown.reset
      end
      @position = @easer.ease(@position, @dest_position, @countdown.rate)
      @countdown.update
    end
  end

end
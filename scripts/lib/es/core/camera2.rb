class Camera2

  attr_accessor :position
  attr_reader :obj

  def initialize
    @position = Vector3.new 0, 0, 0
    @viewport = Moon::Rect.new(-Moon::Screen.width/2, -Moon::Screen.height/2,
                               Moon::Screen.width/2,  Moon::Screen.height/2)
    @ticks = 0
  end

  def follow(obj)
    @obj = obj
  end

  def view
    @position + @viewport.xyz
  end

  def update
    if @obj
      @position += (@obj.position * 32 - @position) * 0.09
    end
    @ticks += 1
  end

end
class Camera2
  attr_accessor :position
  attr_accessor :speed
  attr_reader :obj

  def initialize
    @position = Vector3.new 0, 0, 0
    @viewport = Moon::Rect.new(-Moon::Screen.width/2, -Moon::Screen.height/2,
                               Moon::Screen.width/2,  Moon::Screen.height/2)
    @speed = 4
    @ticks = 0
  end

  def follow(obj)
    @obj = obj
    puts "[Camera:follow] #{obj}"
  end

  def view
    @position + @viewport.xyz
  end

  def update(delta)
    if @obj
      @position += (@obj.position * 32 - @position) * @speed * delta
    end
    @ticks += 1
  end
end

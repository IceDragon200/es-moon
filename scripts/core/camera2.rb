class Camera2 < ::DataModel::Metal
  field :position, type: Vector3, default: proc{Vector3.new}
  field :speed,    type: Integer, default: 4
  field :ticks,    type: Integer, default: 0
  field :obj,      type: Object,  allow_nil: true, default: nil
  field :viewport, type: Rect,    default: (proc do
    Rect.new(-Moon::Screen.width/2, -Moon::Screen.height/2,
              Moon::Screen.width/2,  Moon::Screen.height/2)
  end)

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

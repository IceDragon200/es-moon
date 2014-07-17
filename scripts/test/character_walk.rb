class State::CharacterWalkTest < State
  def init
    super
    @popup = YAML.load_file("data/popups/idling.yml")
    @data = YAML.load_file("data/characters/baron.yml")

    @popup_ss = ES.cache.tileset(@popup["filename"], @popup["cell_width"], @popup["cell_height"])
    @spritesheet = nil

    @popup_frame_rate = @popup["frame_rate"]
    @popup_index = 0
    @popup_frame_time = 0
    @popup_x = 0
    @popup_y = 0
    @popup_ox = 0
    @popup_oy = 0
    @popup_angle = 0

    @idle_time = 0
    @idle = false
    @position = Vector3.new
    @velocity = Vector3[2]
    @direction = Vector3.new

    @input.on :press, :left do
      @direction.x = -1
      set_pose("walk.l")
    end

    @input.on :release, :left do
      @direction.x = 0
      reset_pose("stand.l")
    end

    @input.on :press, :right do
      @direction.x = 1
      set_pose("walk.r")
    end

    @input.on :release, :right do
      @direction.x = 0
      reset_pose("stand.r")
    end

    @input.on :press, :up do
      @direction.y = -1
      set_pose("walk.u")
    end

    @input.on :release, :up do
      @direction.y = 0
      reset_pose("stand.u")
    end

    @input.on :press, :down do
      @direction.y = 1
      set_pose("walk.d")
    end

    @input.on :release, :down do
      @direction.y = 0
      reset_pose("stand.d")
    end

    set_pose("idle")
  end

  def set_pose(pose)
    @pose = pose
    @frame_time = 0
    @pose_data = @data["poses"].fetch(@pose)
    @pose_frame_rate = @pose_data["frame_rate"]
    @pose_sequence = @pose_data["sequence"]
    @spritesheet = ES.cache.tileset(@pose_data["filename"],
                                    @pose_data["cell_width"],
                                    @pose_data["cell_height"])
    refresh_pose
  end

  def reset_pose(*args, &block)
    set_pose(*args, &block) if @direction.zero?
  end

  def refresh_pose
    frame = @pose_sequence[(@frame_time * @pose_frame_rate).to_i % @pose_sequence.size]
    @index = frame["index"]
    @x = frame["x"]
    @y = frame["y"]
    @ox = frame["ox"]
    @oy = frame["oy"]
    @bb = Rect[frame["bounding_box"].symbolize_keys]
  end

  def update_popup(delta)
    if @idle
      sequence = @popup["sequence"]
      frame = sequence[(@popup_frame_time * @popup_frame_rate).to_i % sequence.size]

      @popup_x = frame["x"] if frame["x"]
      @popup_y = frame["y"] if frame["y"]
      @popup_ox = frame["ox"] if frame["ox"]
      @popup_oy = frame["oy"] if frame["oy"]
      @popup_index = frame["index"] if frame["index"]
      @popup_angle = frame["angle"] if frame["angle"]
      @popup_frame_time = (@popup_frame_time + delta) % 255
    else
      @popup_frame_time = 0
    end
  end

  def update_pose(delta)
    refresh_pose
    @frame_time = (@frame_time + delta) % 255
  end

  def update(delta)
    super delta
    if @direction.zero?
      @idle_time += delta
    else # character is moving
      @idle_time = 0
      @position += @velocity * @direction
    end
    update_popup(delta)
    @idle = @idle_time > 4
    if @idle
      set_pose("idle") unless @pose == "idle"
    end
    update_pose(delta)
  end

  def render
    x, y, z = *(@position + [@x, @y, 0])
    @spritesheet.render x, y, z, @index, ox: @ox, oy: @oy
    if @idle
      px, py, pz = x+@popup_x-@ox, y+@popup_y-@popup_oy+@bb.y, z
      @popup_ss.render px, py, pz, @popup_index,
                       angle: @popup_angle, ox: @popup_ox, oy: @popup_oy
    end
    super
  end
end

class ParticleSystem < RenderContainer

  class Particle

    attr_accessor :color # ?

    attr_accessor :cell_index

    attr_accessor :accel
    attr_accessor :force
    attr_accessor :position
    attr_accessor :velocity

    attr_accessor :ticks

    def initialize
      reset
    end

    def reset
      @cell_index = -1
      @accel = Vector3.new 0, 0, 0
      @force = Vector3.new 0, 0, 0
      @position = Vector3.new 0, 0, 0
      @velocity = Vector3.new 0, 0, 0
      @color = Vector4.new 1.0, 1.0, 1.0, 1.0
      @ticks = 0
      self
    end

    def setup(options)
      @cell_index = options[:cell_index] || @cell_index
      @ticks = options[:ticks] || @ticks
      @accel.set(options[:accel] || @accel)
      @force.set(options[:force] || @force)
      @position.set(options[:position] || @position)
      @velocity.set(options[:velocity] || @velocity)
      @color.set(options[:color] || @color)
      self
    end

    def active?
      @ticks > 0
    end

    def expired?
      @ticks == 0
    end

    def expire
      if expired?
        reset
        return true
      end
      false
    end

    def tick
      @ticks -= 1 if active?
      self
    end

  end

  ###
  # Global particle system force, use a negative y value for smoke
  # use a positive y value for gravity
  # feel free to go nuts?
  ###
  attr_accessor :accel
  attr_accessor :force
  attr_accessor :velocity
  attr_accessor :ticks

  attr_reader :active_count

  def initialize(spritesheet, count=128)
    super()
    @spritesheet = spritesheet
    @particles = Array.new(count) { Particle.new }
    @accel = Vector3.new(0, 0, 0)
    @force = Vector3.new(0, 0, 0)
    @velocity = Vector3.new(0, 0, 0)
    @ticks = 0
    @active_count = 0
  end

  def size
    @particles.size
  end

  def add(options)
    # don't go adding new particles that we don't have, just discard it
    if @active_count < @particles.size
      @particles[@active_count].reset.setup({ ticks: @ticks }.merge(options))
      @active_count += 1
    end
  end

  def update
    expired_count = 0
    @active_count.times do |i| particle = @particles[i]
      if particle.active?
        particle.velocity += @accel + particle.accel
        particle.position += @velocity + particle.velocity +
                             @force + particle.force

        if particle.tick.expire
          expired_count += 1
        end
      end
    end
    if expired_count > 0
      @particles.sort_by { |p| p.expired? ? 1 : 0 }
      @active_count -= expired_count
    end
  end

  def render(x, y, z)
    @active_count.times do |i| particle = @particles[i]
      if particle.cell_index != -1
        pos = @position + particle.position + [x, y, z]
        @spritesheet.render(*pos, particle.cell_index)
      end
    end
    super x, y, z
  end

end
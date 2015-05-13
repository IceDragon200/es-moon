module Moon
  class MouseContent < Event
    attr_accessor :inside
    attr_accessor :x
    attr_accessor :y
    attr_accessor :position

    def initialize(s, p)
      @inside = s
      @x = p.x
      @y = p.y
      @position = Moon::Vector2.new(@x, @y)
      super :mouseinside
    end
  end
  class MouseInside < MouseContent
    def initialize(p)
      super true, p
    end
  end
  class MouseOutside < MouseContent
    def initialize(p)
      super false, p
    end
  end
end

module Moon
  class RenderContext
    def enable_mouseinside
      @events ||= {}
      @events[:mouseinside] = on :mousemove do |e|
        if screen_bounds.contains?(e.position)
          trigger Moon::MouseInside.new(e.position)
        else
          trigger Moon::MouseOutside.new(e.position)
        end
      end
    end
  end
end

class Game < Moon::DataModel::Metal
  field :map,   type: ES::EditorMap, default: nil
  field :world, type: ES::World,     default: nil
end

class CameraContext < Moon::RenderContainer
  attr_accessor :camera

  def apply_position_modifier(vec3 = 0)
    pos = super(vec3)
    pos -= @camera.view_offset if @camera
    pos
  end
end

class MapView < Moon::RenderContainer
  attr_reader :dm_map
  attr_reader :tilesize
  attr_reader :world

  def init
    super
    @dm_map = nil
    @world = nil
    @map_renderer = MapRenderer.new
    @entities = Moon::RenderArray.new
    @tilesize = Moon::Vector3.new(32, 32, 32)

    add @map_renderer
    add @entities
  end

  private def add_entity(entity)
    entity_r = EntityRenderer.new
    entity_r.tilesize = @tilesize
    entity_r.entity = entity
    @entities.add entity_r
  end

  private def remove_entity(entity)
    @entities.reject! { |r| r.entity == entity }
  end

  def init_events
    super
    on :entity_added do |e|
      add_entity e.entity
    end

    on :entity_removed do |e|
      remove_entity e.entity
    end
  end

  def refresh_world
    @entities.clear
    @world.entities.each do |entity|
      add_entity entity
    end
  end

  def refresh_tilesize
    @entities.each { |e| e.tilesize = @tilesize }
  end

  def dm_map=(dm_map)
    @dm_map = dm_map
    @map_renderer.dm_map = @dm_map
  end

  def world=(world)
    @world = world
    refresh_world
  end

  def tilesize=(tilesize)
    @tilesize = tilesize
    refresh_tilesize
  end
end

module Dataman
  def self.load_editor_map(query)
    map = ES::Map.find_by(query)
    em = map.to_editor_map
    em.chunks = map.chunks.map do |chunk_head|
      chunk = ES::Chunk.find_by(uri: chunk_head.uri)
      editor_chunk = chunk.to_editor_chunk
      editor_chunk.position = chunk_head.position
      editor_chunk.tileset = ES::Tileset.find_by(uri: chunk.tileset.uri)
      editor_chunk
    end
    em
  end
end

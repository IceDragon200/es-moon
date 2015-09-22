require 'scripts/renderers/entity_renderer'

class PopupSpriteset < Moon::RenderContainer
  def initialize_members
    super
    @scheduler = Moon::Scheduler.new
  end

  def add_popup(popup)

  end
end

class MapView < Moon::RenderContainer
  attr_reader :popups

  def initialize_content
    super
    @map = nil
    @world = nil
    @tilesize = Moon::Vector3.new(32, 32, 32)
    @popups = PopupSpriteset.new
    @map_renderer = MapRenderer.new
    @entities = Moon::RenderContainer.new

    add @map_renderer
    add @entities
    add @popups
  end

  private def add_entity(entity)
    entity_r = EntityRenderer.new
    entity_r.tilesize = @tilesize
    entity_r.entity = entity
    @entities.add entity_r
  end

  private def remove_entity(entity)
    @entities.elements.reject! { |r| r.entity == entity }
  end

  def initialize_events
    super
    on :entity_added do |e|
      add_entity e.entity
    end

    on :entity_removed do |e|
      remove_entity e.entity
    end
  end

  def refresh_world
    @entities.clear_elements
    @world.entities.each do |entity|
      add_entity entity
    end
  end

  def refresh_tilesize
    @entities.elements.each { |e| e.tilesize = @tilesize }
  end

  attr_reader :map
  def map=(map)
    @map = map
    @map_renderer.map = @map
  end

  attr_reader :world
  def world=(world)
    @world = world
    refresh_world
  end

  attr_reader :tilesize
  def tilesize=(tilesize)
    @tilesize = tilesize
    refresh_tilesize
  end
end

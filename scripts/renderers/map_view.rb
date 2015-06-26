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
  attr_reader :dm_map
  attr_reader :tilesize
  attr_reader :world

  def initialize_content
    super
    @dm_map = nil
    @world = nil
    @tilesize = Moon::Vector3.new(32, 32, 32)
    @popups = PopupSpriteset.new
    @map_renderer = MapRenderer.new
    @entities = Moon::RenderArray.new

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
    @entities.reject! { |r| r.entity == entity }
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

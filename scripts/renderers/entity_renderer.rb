require 'scripts/renderers/gauge_renderer'

class EntityRenderer < Moon::RenderContext
  attr_accessor :index
  attr_accessor :tilesize
  attr_reader :entity

  def initialize_members
    super
    @index = 0
    @entity = nil
    @sprite = nil
    @tilesize = Moon::Vector3.new 32, 32, 0
  end

  def create_sprite
    texture = TextureCache.resource @filename
    @sprite = Moon::Sprite.new texture
    if @clip_rect
      @sprite.clip_rect = Moon::Rect.new(0, 0, 0, 0).set(@clip_rect)
    end
    @sprite.ox = @sprite.w / 2
    @sprite.oy = @sprite.h / 2
  end

  def create_hp_gauge
    @hp_gauge = GaugeRenderer.new
    hp_gauge_texture = TextureCache.gauge 'gauge_48x6_hp.png'
    if team_component = @entity[:team]
      hp_gauge_texture = case team_component.number
      when Enum::Team::ENEMY
        TextureCache.gauge 'gauge_48x6_red.png'
      else
        hp_gauge_texture
      end
    end
    @hp_gauge.set_texture hp_gauge_texture, 48, 6
  end

  def create_mp_gauge
    @mp_gauge = GaugeRenderer.new
    @mp_gauge.set_texture TextureCache.gauge('gauge_48x4_mp.png'), 48, 4
  end

  def create_gauges
    create_hp_gauge
    create_mp_gauge
  end

  def on_entity_changed
    if @entity && (data = @entity[:sprite])
      @filename = data.filename
      @clip_rect = data.clip_rect
      create_sprite
      create_gauges
    end
  end

  def entity=(entity)
    @entity = entity
    @sprite = nil
    on_entity_changed
  end

  def update_content(delta)
    return unless @entity
    return unless @sprite
    if health = @entity[:health]
      @hp_gauge.rate = health.rate if @hp_gauge.rate != health.rate
      @hp_gauge.show unless @hp_gauge.visible?
    else
      @hp_gauge.rate = 0
      @hp_gauge.hide if @hp_gauge.visible?
    end
    if mana = @entity[:mana]
      @mp_gauge.rate = mana.rate if @mp_gauge.rate != mana.rate
      @mp_gauge.show unless @mp_gauge.visible?
    else
      @mp_gauge.rate = 0
      @mp_gauge.hide if @mp_gauge.visible?
    end
  end

  def render_content(x, y, z, options)
    return unless @entity
    return unless @sprite

    @entity.comp :transform, :sprite  do |t, s|
      charpos = t.position * @tilesize + [x, y, z]

      sx = charpos.x + (@tilesize.x - @sprite.ox) / 2
      sy = charpos.y + (@tilesize.y - @sprite.oy) / 2
      sz = charpos.z
      @sprite.render sx, sy, sz
      @mp_gauge.render sx + @sprite.ox, sy, sz, options
      @hp_gauge.render sx + @sprite.ox, sy - @mp_gauge.h, sz, options

      s.bounds ||= Moon::Cuboid.new
      s.bounds.set sx, sy, sz, @sprite.w, @sprite.h, 1
    end
  end
end

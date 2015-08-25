require 'scripts/utils/vbo_tools'
require 'scripts/entity_system/system'

class RenderingSystem < ES::EntitySystem::System
  register :rendering

  def post_initialize
    super
    @transform = Moon::Matrix4.new 1.0
    @render_mode = Moon::OpenGL::TRIANGLES

    @material = nil
    @texture = nil
    @batch = []
  end

  def update(delta)
    #
  end

  def flush
    return unless @material
    @material.use
    @material.bind_texture(@texture) if @texture
    @batch.each do |entity|
      sprite = entity[:sprite]
      @transform.set(Moon::Renderer.instance.projection_matrix)
      if t = entity[:transform]
        @transform.mul(t.matrix)
      end
      @material.shader.set_uniform('mvp_matrix', @transform)
      sprite.vbo.render(@render_mode, sprite.vertex_index)
    end
    @batch.clear
  end

  def setup_texture(sprite)
    if fn = sprite.filename
      sprite.texture ||= ES.game.texture_cache[fn]
    end
  end

  def setup_spritesheet_vbo(sprite)
    cols = (sprite.texture.w / sprite.cell_w).to_i
    rows = (sprite.texture.h / sprite.cell_h).to_i
    cw = sprite.cell_w
    raise ArgumentError, "cell_w must be greater than 0" unless cw > 0
    ch = sprite.cell_h
    raise ArgumentError, "cell_h must be greater than 0" unless ch > 0
    tx_cw = cw.to_f / sprite.texture.w.to_f
    tx_ch = ch.to_f / sprite.texture.h.to_f
    rect = [0, 0, cw, ch]
    color = [1, 1, 1, 1]
    sprite.vbo.push_indices Moon::VertexBuffer::QUAD_INDICES
    rows.times do |row|
      cols.times do |col|
        sprite.vbo.add_quad_vertices(rect, [col * tx_cw, row * tx_ch, tx_cw, tx_ch], color)
      end
    end
  end

  def setup_vbo(sprite)
    return if sprite.last_type == sprite.type
    sprite.vbo ||= Moon::VertexBuffer.new(Moon::VertexBuffer::DYNAMIC_DRAW)
    sprite.vbo.clear
    case sprite.type
    when :sprite
      sprite.vbo.add_quad([0, 0, sprite.texture.w, sprite.texture.h], [0, 0, 1, 1], [1, 1, 1, 1])
    when :spritesheet
      setup_spritesheet_vbo(sprite)
    else
      raise RuntimeError, "unrecognized sprite.type #{sprite.type}!"
    end
    sprite.last_type = sprite.type
  end

  def setup_clip_rect(sprite)
    return unless sprite.type == :sprite
    if sprite.last_clip_rect != sprite.clip_rect
      puts "Refreshing VBO"
      sprite.vbo.clear

      color = [1, 1, 1, 1]
      if sprite.clip_rect
        vbo.add_quad([0, 0, sprite.clip_rect.w, sprite.clip_rect.h], VboTools.rect_to_texrect(sprite.clip_rect, sprite.texture), color)
      else
        vbo.add_quad([0, 0, sprite.texture.w, sprite.texture.h], [0, 0, 1, 1], color)
      end

      sprite.last_clip_rect = sprite.clip_rect
    end
  end

  def setup_material(sprite)
    if sprite.material_id != sprite.last_material_id
      sprite.material = game.materials.fetch(sprite.material_id)
    end
  end

  def render(x, y, z, options)
    @world.filter :sprite do |entity|
      sprite = entity[:sprite]
      setup_texture(sprite)
      setup_vbo(sprite)
      setup_clip_rect(sprite)
      setup_material(sprite)

      if @texture != sprite.texture || @material != sprite.material
        flush
        @texture = sprite.texture
        @material = sprite.material
      end

      @batch << entity
    end

    flush
  end
end

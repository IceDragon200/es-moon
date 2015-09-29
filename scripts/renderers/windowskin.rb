require 'scripts/utils/vbo_tools'

module Renderers
  class Windowskin < Moon::RenderContext
    # color used for render
    SHADER_COLOR = Moon::Vector4.new(1, 1, 1, 1)
    # tone used for render
    SHADER_TONE = Moon::Vector4.new(0, 0, 0, 1)

    extend Moon::TypedAttributes

    attribute :opacity,  Float
    attribute :src_rect, Moon::Rect
    attribute :color,    Moon::Vector4
    attribute :texture,  Moon::Texture
    attribute :shader,   Moon::Shader

    # Call this method if you want to forcible refresh the windowskin
    #
    # @return [self]
    def refresh
      generate_part_rects
      generate_buffers
      self
    end

    private def generate_buffers
      @vbo.clear
      rect = [0, 0, w, h]
      VboTools.fill_windowskin_vbo(@vbo, rect, @texture, @color, @part_rects)
    end

    private def generate_part_rects
      x, y, w, h = *@src_rect
      cw, ch = w / 3, h / 3
      9.times do |i|
        @part_rects[i].set(x + (cw * (i % 3)), y + (ch * (i / 3).to_i), cw, ch)
      end
    end

    alias :set_texture :texture=
    # @param [Moon::Texture] texture
    def texture=(texture)
      set_texture texture
      generate_buffers
    end

    alias :set_color :color=
    # @param [Moon::Vector4] color
    def color=(color)
      set_color color
      generate_buffers
    end

    alias :set_src_rect :src_rect=
    # @param [Moon::Rect] src_rect
    def src_rect=(src_rect)
      set_src_rect src_rect
      generate_part_rects
      generate_buffers
    end

    protected def on_resize(*_attrs)
      super
      generate_buffers
    end

    protected def initialize_members
      super
      @opacity = 1.0
      @transform = Moon::Matrix4.new
      @mode = @mode = Moon::OpenGL::TRIANGLES
      @part_rects = Array.new(9) { Moon::Rect.new }
    end

    protected def initialize_content
      super
      @vbo = Moon::VertexBuffer.new(Moon::VertexBuffer::DYNAMIC_DRAW)
      # TODO, moon should expose its default shaders, instead of
      # having to take it from an existing class
      self.shader = Moon::Sprite.default_shader
    end

    protected def initialize_from_options(options)
      super
      set_texture options.fetch(:texture)
      set_color options.fetch(:color) { Moon::Vector4.new(1, 1, 1, 1) }
      set_src_rect(options.fetch(:src_rect) do
        Moon::Rect.new(0, 0, texture.w, texture.h)
      end)
    end

    protected def post_initialize
      super
      refresh
    end

    protected def render_content(x, y, z)
      @transform.clear
      @transform.translate!(x, y, z)

      @shader.use
      @shader.set_uniform 'opacity', @opacity
      @shader.set_uniform 'color', SHADER_COLOR
      @shader.set_uniform 'tone', SHADER_TONE

      Moon::Renderer.instance.render(@shader, @vbo, @texture, @transform, @mode)
    end
  end
end

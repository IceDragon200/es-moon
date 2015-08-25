module States
  module Test
    class Material < States::Base
      def start
        @texture = game.texture_cache.texture('resources/backgrounds/blue.png')
        @vbo = Moon::VertexBuffer.new(Moon::VertexBuffer::DYNAMIC_DRAW)
        @vbo.add_quad([0, 0, @texture.w, @texture.h], [0, 0, 1, 1], [1, 1, 1, 1])
        @shader = Moon::Sprite.default_shader
        @transform = Moon::Matrix4.new 1.0
        @transform.set(Moon::Renderer.instance.projection_matrix)
        @material = ::Material.new(Moon::Sprite.default_shader)
        @material.set_uniform('opacity', 1.0)
        @material.set_uniform('color', Color::WHITE)
        @material.set_uniform('tone', Color::BLACK)
        @material.set_uniform('mvp_matrix', @transform)
        @material.textures << @texture
      end

      def render
        @material.use
        @vbo.render Moon::OpenGL::TRIANGLES
      end
    end
  end
end

class Material
  @@id = 0

  attr_reader :id
  attr_reader :uniforms
  attr_accessor :shader
  attr_accessor :textures

  # @param [Moon::Shader] shader
  def initialize(shader)
    @id = @@id += 1
    @shader = shader
    @uniforms = {}
    @textures = []
  end

  # @param [String] key
  def get_uniform(key)
    @uniforms[key]
  end

  # @param [String] key
  # @param [Object] value
  def set_uniform(key, value)
    if value.nil?
      @uniforms.delete(key)
    else
      @uniforms[key] = value
    end
  end

  # @param [Moon::Texture] texture
  # @param [Integer] index
  def bind_texture(texture, index = 0)
    Moon::OpenGL.active_texture(Moon::OpenGL::TEXTURE0 + index)
    texture.bind
    @shader.set_uniform("tex#{index}", index)
  end

  def use
    @shader.use
    @uniforms.each_pair do |key, value|
      @shader.set_uniform(key, value)
    end
    @textures.each_with_index do |texture, index|
      bind_texture(texture, index)
    end
  end
end

class ChunkRenderer
  attr_reader :chunk

  def initialize(chunk)
    @tilemap = Tilemap.new
    self.chunk = chunk
  end

  def position
    @chunk.position
  end

  def position=(position)
    @chunk.position = position
  end

  def layer_opacity
    @tilemap.layer_opacity
  end

  def layer_opacity=(layer_opacity)
    @tilemap.layer_opacity = layer_opacity
  end

  def refresh
    tileset = @chunk.tileset
    @tilemap.tileset = ES.cache.tileset(tileset.filename,
                                        tileset.cell_width, tileset.cell_height)
    @tilemap.data = @chunk.data
    @tilemap.flags = @chunk.flags
    @size = Vector3.new(tileset.cell_width, tileset.cell_height, 1)
  end

  def chunk=(chunk)
    @chunk = chunk
    refresh
  end

  def render(x=0, y=0, z=0, options={})
    @tilemap.render(*((position*@size) + [x, y, z]), options)
  end
end

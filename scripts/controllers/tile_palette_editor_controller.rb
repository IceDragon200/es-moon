class TilePaletteEditorController < State::ControllerBase
  def initialize_controller
    super

  end

  def tileset_cursor_to_tile_id
    (@model.tileset_cursor.position.x + @model.tileset_cursor.position.y * @model.tileset.columns).to_i
  end

  def move_tileset_cursor(x, y)
    @model.tileset_cursor.position += [x, y, 0]
    @model.tileset_cursor.position.x = [[@model.tileset_cursor.position.x, 0].max, @model.tileset.columns-1].min
    @model.tileset_cursor.position.y = 0 if @model.tileset_cursor.position.y < 0
  end

  def move_palette_cursor(x, y)
    @model.palette_cursor.position += [x, y, 0]
    @model.palette_cursor.position.x = [[@model.palette_cursor.position.x, 0].max, @model.tile_palette.columns-1].min
    @model.palette_cursor.position.y = [[@model.palette_cursor.position.y, 0].max, @model.tile_palette.rows-1].min
  end

  def add_to_palette
    @model.tile_palette.tiles << tileset_cursor_to_tile_id
  end

  def remove_from_palette
    @model.tile_palette.tiles.delete(tileset_cursor_to_tile_id)
  end

  def jump_to_tile
  end

  def update_controller(delta)
    super
  end
end

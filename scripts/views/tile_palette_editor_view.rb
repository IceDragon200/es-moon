class TilePaletteEditorView < State::ViewBase
  def initialize_view
    super
    @tile_palette_panel = TilePalettePanel.new
    @tileset_panel = TilesetPanel.new
    @info_panel = TilePaletteInfoPanel.new

    @tileset_panel.position.set(0, 128, 0)
    @info_panel.position.set(engine.screen.w - 128, 0, 0)

    add(@tile_palette_panel)
    add(@tileset_panel)
    add(@info_panel)
  end

  def refresh
    @tile_palette_panel.tile_palette = @model.tile_palette
    @info_panel.tile_palette = @tile_palette_panel.tile_palette
    @tileset_panel.tileset = @model.tile_palette.tileset
  end

  def update_view(delta)
    @tile_palette_panel.cursor_position = @model.palette_cursor.position
    @tileset_panel.cursor_position = @model.tileset_cursor.position
    super(delta)
  end
end

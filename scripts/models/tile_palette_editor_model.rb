class TilePaletteEditorModel < State::ModelBase
  field :palette_cursor, type: TileCursor, default: proc{|t|t.new}
  field :tileset_cursor, type: TileCursor, default: proc{|t|t.new}
  field :tile_palette, type: Models::TilePalette, allow_nil: true, default: nil
  field :tileset,      type: Models::Tileset, allow_nil: true, default: nil
end

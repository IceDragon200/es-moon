class TilePaletteInfoPanel < Moon::RenderContainer
  attr_accessor :tile_palette

  def initialize
    super
    @text = Moon::Label.new('', FontCache.font('uni0553', 16))
    @tile_palette = nil
    add(@text)
  end

  def update_content(delta)
    if @tile_palette
      @text.string = "columns: #{@tile_palette.columns}\n" +
                     "rows: #{@tile_palette.rows}\n" +
                     "\n" +
                     "\n"
    else
      @text.string = ''
    end
    super
  end
end

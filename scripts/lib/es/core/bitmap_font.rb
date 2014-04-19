class BitmapFont < RenderContainer

  attr_accessor :string
  attr_accessor :bold

  ###
  # Current font cell size is fixed at 8x8
  # @param [String] filename font file name
  # @param [String] string initial ASCII string value
  ###
  def initialize(filename, string="")
    super()
    @cell_size = [8, 8]
    @spritesheet = Cache.bmpfont filename, *@cell_size
    @string = string
    @bold = false
  end

  def width
    @string.size * @cell_size[0]
  end

  def height
    (@string.count("\n") + 1) * @cell_size[1]
  end

  ###
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] z
  ###
  def render(x, y, z)
    if @string
      offset = @bold ? 256 : 0
      row = 0
      px, py, pz = *@position
      @string.to_s.bytes.each_with_index do |byte, i|
        next row += 1 if byte.chr == "\n"
        @spritesheet.render px + x + i * @cell_size[0],
                            py + y + row * @cell_size[1],
                            pz + z,
                            byte + offset
      end
    end
    super x, y, z
  end

end
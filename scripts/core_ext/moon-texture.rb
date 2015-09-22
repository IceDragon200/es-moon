module Moon
  class Texture
    # Creates and returns a Rect representing the size of the texture
    #
    # @return [Moon::Rect]
    def to_rect
      Moon::Rect.new(0, 0, w, h)
    end
  end
end

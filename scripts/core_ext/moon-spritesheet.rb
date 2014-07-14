module Moon
  class Spritesheet
    include Containable

    def cell_size
      Vector2.new cell_width, cell_height
    end
  end
end

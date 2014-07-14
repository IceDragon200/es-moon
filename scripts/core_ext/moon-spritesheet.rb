module Moon
  class Spritesheet
    def cell_size
      Vector2.new cell_width, cell_height
    end

    def containerize
      container = RenderContainer.new
      container.add(self)
      container
    end
  end
end

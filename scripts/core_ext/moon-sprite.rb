module Moon
  class Sprite
    def containerize
      container = RenderContainer.new
      container.add(self)
      container
    end
  end
end

module Moon
  class RenderContainer
    include Visibility

    def containerize
      container = RenderContainer.new
      container.add(self)
      container
    end
  end
end

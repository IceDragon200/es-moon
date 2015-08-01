module Moon
  class Spritesheet
    # Returns a Vector2 representing the cell sizes of the Spritesheet.
    #
    # @return [Vector2]
    def cell_size
      @cell_size ||= Vector2.new w, h
    end
  end
end

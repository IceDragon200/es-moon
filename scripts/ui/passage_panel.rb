module UI
  class PassagePanel < Moon::RenderContext
    # @!attribute passage
    #   @return [Moon::Spritesheet]
    attr_accessor :spritesheet

    # @!attribute passage
    #   @return [Integer]
    attr_accessor :passage

    protected

    def initialize_members
      super
      @passage = 0
    end

    def initialize_from_options(options)
      super
      @spritesheet = options.fetch(:spritesheet)

      resize @spritesheet.w * 3, @spritesheet.h * 3
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @param [Hash] options
    def render_content(x, y, z, options)
      m = @passage.masked?(Enum::Passage::UP)
      @spritesheet.render x + @spritesheet.w, y, z, m ? 1 : 0

      m = @passage.masked?(Enum::Passage::DOWN)
      @spritesheet.render x + @spritesheet.w, y + @spritesheet.h * 2, z, m ? 1 : 0

      m = @passage.masked?(Enum::Passage::LEFT)
      @spritesheet.render x, y + @spritesheet.h, z, m ? 1 : 0

      m = @passage.masked?(Enum::Passage::RIGHT)
      @spritesheet.render x + @spritesheet.w * 2, y + @spritesheet.h, z, m ? 1 : 0

      m = @passage.masked?(Enum::Passage::ABOVE)
      @spritesheet.render x + @spritesheet.w, y + @spritesheet.h, z, m ? 2 : 3
    end
  end
end

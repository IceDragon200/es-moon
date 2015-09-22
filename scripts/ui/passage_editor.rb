module UI
  # UI component for editing passage flags
  # The flag is disabled as:
  #    U
  #   LAR
  #    D
  # Where U=UP, L=LEFT, A=ABOVE, R=RIGHT, D=DOWN
  # Left clicking on any of the blocks will flip the flag and trigger a
  # {PassageEditor::PassageChanged} (passage_changed) event
  class PassageEditor < Moon::RenderContext
    class PassageChanged < Moon::Event
      # @return [Integer]
      attr_accessor :passage

      # @param [Integer] passage
      def initialize(passage)
        @passage = passage
        super :passage_changed
      end
    end

    # @!attribute passage
    #   @return [Integer]
    attr_accessor :passage

    private

    # @param [Integer] new_passage
    def change_passage(new_passage)
      @passage = new_passage
      trigger { PassageChanged.new(@passage) }
    end

    # Determines where the user clicked in the passage editor, flips flags
    # if they clicked on any of the valid tiles
    #
    # @param [Moon::MouseInputEvent] event
    def on_click(event)
      rel = screen_to_relative(event.position)
      col = (rel.x / @ss.w).to_i
      row = (rel.y / @ss.h).to_i

      flag = if event.shift?
        0xF # flip all flags
      elsif col == 1 && row == 0
        Enum::Passage::UP
      elsif col == 1 && row == 2
        Enum::Passage::DOWN
      elsif col == 0 && row == 1
        Enum::Passage::LEFT
      elsif col == 2 && row == 1
        Enum::Passage::RIGHT
      elsif col == 1 && row == 1
        Enum::Passage::ABOVE
      else
        0
      end

      flag = 0xF ^ flag if event.alt? # flip all other flags except the target one
      change_passage @passage ^ flag
    end

    def initialize_members
      super
      @passage = 0
    end

    def initialize_content
      super
      texture = Game.instance.textures['ui/passage_editor_icons']
      @ss = Moon::Spritesheet.new(texture, 16, 16)
      resize @ss.w * 3, @ss.h * 3
    end

    def initialize_events
      super
      input.on :press do |e|
        if e.is_a?(Moon::MouseInputEvent) && contains_pos?(e.position)
          on_click(e) if e.button == :mouse_left
        end
      end
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @param [Hash] options
    def render_content(x, y, z, options)
      m = @passage.masked?(Enum::Passage::UP)
      @ss.render x + @ss.w, y, z, m ? 1 : 0

      m = @passage.masked?(Enum::Passage::DOWN)
      @ss.render x + @ss.w, y + @ss.h * 2, z, m ? 1 : 0

      m = @passage.masked?(Enum::Passage::LEFT)
      @ss.render x, y + @ss.h, z, m ? 1 : 0

      m = @passage.masked?(Enum::Passage::RIGHT)
      @ss.render x + @ss.w * 2, y + @ss.h, z, m ? 1 : 0

      m = @passage.masked?(Enum::Passage::ABOVE)
      @ss.render x + @ss.w, y + @ss.h, z, m ? 2 : 3
    end
  end
end

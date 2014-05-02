
class AwesomeButton < Widget

  attr_reader :text

  def initialize(parent)
    super(parent, 0, 0, 48, 48)
    @text = text

    @text = Text.new "", Cache.font("awesome", 40)
  end

  def z
    0
  end

  def render(x=0, y=0, z=0)
    super()
    @text.render self.x + x + (width-@text.font.size)/2,
                 self.y + y + (height-@text.font.size)/2,
                 self.z + z
  end

end

module ES
  module UI

    class MapEditorDashboard < RenderLayer

      def initialize
        super
        @new_chunk_button = AwesomeButton.new self
        @new_chunk_button.text.string = ES::FontStringMap::Awesome["plus-square"]
        @new_chunk_button.text.color.set 0.3137, 0.7843, 0.4706, 1.0000
        add @new_chunk_button
      end

    end
  end
end
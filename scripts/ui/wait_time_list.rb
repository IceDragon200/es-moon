module UI
  class WaitTimeList < Moon::RenderContext
    attr_accessor :world

    def initialize_content
      super
      font = Game.instance.fonts['system.16']
      @text = Moon::Text.new(font, '')
    end

    def render_content(x, y, z, options)
      row = 0
      world.filter(:wait_time) do |entity|
        wt = entity[:wait_time]
        @text.string = "#{entity[:name].string}: WT #{wt.value} / #{wt.max} ~#{wt.reset}"
        @text.render x, y + row * 16, z
        row += 1
      end
    end
  end
end

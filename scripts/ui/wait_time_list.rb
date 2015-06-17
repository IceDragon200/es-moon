module UI
  class WaitTimeList < Moon::RenderContext
    attr_accessor :world

    def initialize_content
      super
      @font = FontCache.font('system', 16)
    end

    def render_content(x, y, z, options)
      row = 0
      world.filter(:wait_time) do |entity|
        wt = entity[:wait_time]
        str = "#{entity[:name].string}: WT #{wt.value} / #{wt.max} ~#{wt.reset}"
        @font.render x, y + row * 16, z, str
        row += 1
      end
    end
  end
end

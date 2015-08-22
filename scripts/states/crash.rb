module States
  class Crash < Base
    def init
      super
      ex = cvar['exc']
      tex = game.texture_cache.background 'crash.png'
      @background = Moon::Sprite.new(tex).to_sprite_context
      @text = Moon::Label.new(format_exception(ex), backtrace_font)
      @gui.add @background
      @gui.add @text
    end

    def format_exception(ex)
      ex.inspect +
      "\n" +
      ex.backtrace.join("\n")
    end

    def backtrace_font
      game.font_cache.font('vera', 10)
    end

    def start
      super
    end
  end
end

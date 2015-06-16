module States
  class Crash < Base
    def init
      super
      ex = cvar['exc']
      tex = TextureCache.background 'crash.png'
      @background = Moon::Sprite.new(tex).to_sprite_context
      @text = Moon::Text.new(format_exception(ex), backtrace_font)
      @gui.add @background
      @gui.add @text
    end

    def format_exception(ex)
      ex.inspect +
      "\n" +
      ex.backtrace.join("\n")
    end

    def backtrace_font
      FontCache.font('vera', 10)
    end

    def start
      super
    end
  end
end

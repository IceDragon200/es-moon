module States
  class EsSplash < Splash
    def init
      super
      @sounds = []
      @sounds[0] = Moon::Sound.new('resources/sfx/ISTS-EndTurn.ogg', 'ogg')
      @sounds[1] = Moon::Sound.new('resources/sfx/ISTS-OptionChange.ogg', 'ogg')
      @sounds[2] = Moon::Sound.new('resources/sfx/ISTS-OptionChange2.ogg', 'ogg')
      tex = TextureCache.resource 'splash/es_logo2.png'
      font = FontCache.font 'uni0553', 16
      str = "Earthen : Smiths #{ES::Version::STRING}"
      @text = Moon::Label.new(str, font)
      @text.color = Moon::Vector4.new(0, 0, 0, 1.0)
      @moon_logo = Moon::Sprite.new(tex)
      @moon_logo.ox = @moon_logo.w / 2
      @moon_logo.oy = @moon_logo.h / 2
      @moon_logo.opacity = 0.0
      @moon_logo.angle = -180
      @pos = Moon::Vector2.new(0, -32)
    end

    def start
      super
      t = TweenScheduler.new(scheduler)
      d = '1s 500'
      e = Moon::Easing::BackOut

      scheduler.in '100' do
        @sounds[0].play
        t.tween_obj screen, :clear_color, to: Moon::Vector4.new(1.0, 1.0, 1.0, 1.0), duration: d, easer: e
      end

      scheduler.in '1s' do
        t.tween_obj @moon_logo, :opacity, from: 0.0, to: 1.0, duration: d, easer: e
        i = 0
        job = scheduler.every '500' do
          @sounds[1].play
          i += 1
          t.tween_obj @moon_logo, :angle, to: -180 + i * 45, duration: '750', easer: e
        end

        scheduler.in '2s' do
          scheduler.remove job
        end

        scheduler.in '3s 500' do
          t.tween_obj @pos, :y, to: 0, duration: '1s', easer: e
        end

        scheduler.in '4s' do
          @sounds[2].play
          t.tween_obj @moon_logo, :angle,   to: 180, duration: d, easer: e
          t.tween_obj @moon_logo, :opacity, to: 0.0, duration: d, easer: e
          t.tween_obj @pos, :x, to: @moon_logo.ox * 3, duration: d, easer: e
          t.tween_obj screen, :clear_color, to: Moon::Vector4.new(0.0, 0.0, 0.0, 0.0), duration: d, easer: e

          scheduler.in '500' do
            finish
          end
        end
      end
      scheduler.print_jobs
    end

    def restore_clear_color
      screen.clear_color = Moon::Vector4.new(0.0, 0.0, 0.0, 0.0)
    end

    def finish
      restore_clear_color
      super
    end

    #def update(delta)
    #  super
    #  #scheduler.print_jobs
    #end

    def render
      x = (screen.w - @moon_logo.w) / 2 + @pos.x
      y = (screen.h - @moon_logo.h) / 2 + @pos.y
      @moon_logo.render x, y, 0
      x = (screen.w - @moon_logo.w) / 2
      y = (screen.h - @moon_logo.h) / 2
      @text.render x, y + @moon_logo.h, 0, opacity: @moon_logo.opacity
      super
    end
  end
end

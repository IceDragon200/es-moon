class State

  alias :init_wo_version_bmpfont :init
  def init
    init_wo_version_bmpfont

    @beta_layer = RenderLayer.new

    bmpfont = BitmapFont.new("font_cga8_white.png")
    bmpfont.set_string("moon-0.1.0")
    bmpfont.position.set(Moon::Screen.width - bmpfont.width, 0, 0)

    @beta_layer.add(bmpfont)

    bmpfont2 = BitmapFont.new("font_cga8_white.png")
    bmpfont2.set_string("es-moon-#{ES::Version::STRING}")

    @beta_layer.add(bmpfont2)

    @beta_layer.position.set(Moon::Screen.width - @beta_layer.width,
                             Moon::Screen.height - @beta_layer.height, 0)
  end

  def render
    @beta_layer.render
  end

end

module ES
  module States
  end
end

require 'scripts/lib/es/states/shutdown'
require 'scripts/lib/es/states/splash'
require 'scripts/lib/es/states/title'
require 'scripts/lib/es/states/map'
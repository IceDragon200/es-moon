class State

  #alias :init_wo_version_bmpfont :init
  #  def init
  #    init_wo_version_bmpfont
  #
  #    @beta_layer = RenderLayer.new
  #
  #    font = Cache.font "uni0553", 14
  #
  #    text = Text.new("moon-0.1.0", font)
  #    text.position.set(Moon::Screen.width - text.width, 0, 0)
  #
  #    @beta_layer.add(text)
  #
  #    text = Text.new("es-moon-#{ES::Version::STRING}", font)
  #
  #    @beta_layer.add(text)
  #
  #    @beta_layer.position.set(Moon::Screen.width - @beta_layer.width,
  #                             Moon::Screen.height - @beta_layer.height, 0)
  #end

  #def render
  #  @beta_layer.render
  #end

end

module ES
  module States
  end
end

require 'scripts/lib/es/states/shutdown'
require 'scripts/lib/es/states/splash'
require 'scripts/lib/es/states/title'
require 'scripts/lib/es/states/map'
require 'scripts/lib/es/states/map_editor'
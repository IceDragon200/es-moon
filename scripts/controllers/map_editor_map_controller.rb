class MapEditorMapController < State::ControllerBase
  attr_accessor :gui_controller

  def refresh_map
    @view.refresh_tilemaps
  end

  def refresh_layer_opacity
    @view.refresh_layer_opacity
  end

  def layer_opacity=(lop)
    @model.layer_opacity = lop
    refresh_layer_opacity
  end

  def on_show_grid
    @view.refresh_grid
  end
end

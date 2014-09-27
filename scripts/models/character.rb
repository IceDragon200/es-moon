module ES
  class CharacterSequenceFrame < Moon::DataModel::Metal
    field :index,        type: Integer, allow_nil: true
    field :ox,           type: Integer, allow_nil: true
    field :oy,           type: Integer, allow_nil: true
    field :x,            type: Integer, allow_nil: true
    field :y,            type: Integer, allow_nil: true
    field :bounding_box, type: Moon::Rect, allow_nil: true
  end

  class Pose < Moon::DataModel::Metal
    field :filename,    type: String,  default: ""
    field :cell_width,  type: Integer, default: 32
    field :cell_height, type: Integer, default: 32
    field :frame_rate,  type: Integer, default: 8
    array :sequence,    type: CharacterSequenceFrame
  end

  class Character < Moon::DataModel::Metal
    field :name,  type: String, default: ""
    field :uri,   type: String, default: ""
    field :poses, type: {String=>Pose}, default: proc {{}}
  end
end

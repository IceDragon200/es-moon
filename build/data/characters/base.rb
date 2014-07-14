require_relative '../sequence_builder'

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
  field :sequence,    type: [CharacterSequenceFrame], default: proc {[]}
end

class Character < Moon::DataModel::Metal
  field :name,  type: String, default: ""
  field :uri,   type: String, default: ""
  field :poses, type: {String=>Pose}, default: proc {{}}
end

class PoseBuilder

  attr_reader :_pose

  delegate :filename, to: :@_pose
  delegate :cell_width, to: :@_pose
  delegate :cell_height, to: :@_pose
  delegate :frame_rate, to: :@_pose
  delegate :sequence, to: :@_pose

  delegate :filename=, to: :@_pose
  delegate :cell_width=, to: :@_pose
  delegate :cell_height=, to: :@_pose
  delegate :frame_rate=, to: :@_pose
  delegate :sequence=, to: :@_pose

  def initialize(pose=nil)
    @_pose = pose || Pose.new
  end

  def setup_sequence
    builder = SequenceBuilder.new(CharacterSequenceFrame)
    yield builder
    @_pose.sequence = builder.frames
  end

end

class PoseListBuilder

  attr_reader :list
  attr_reader :default_options

  def initialize
    @default_options = {}
    @list = {}
  end

  def pose(key)
    builder = PoseBuilder.new(Pose.new(@default_options))
    yield builder
    @list[key] = builder._pose
  end

  def copy_pose(src, dest)
    pose = @list[dest] = @list[src].dup
    yield PoseBuilder.new(pose) if block_given?
  end

end

def render_pose_list
  builder = PoseListBuilder.new
  yield builder
  builder.list
end

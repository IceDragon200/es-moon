require_relative '../sequence_builder'

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
    @_pose = pose || ES::DataModel::Pose.new
  end

  def setup_sequence
    builder = SequenceBuilder.new(ES::DataModel::CharacterSequenceFrame)
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
    builder = PoseBuilder.new(ES::DataModel::Pose.new(@default_options))
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

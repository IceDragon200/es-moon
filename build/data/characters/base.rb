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

  def initialize(pose = nil)
    @_pose = pose || ES::Pose.new
  end

  def setup_sequence
    builder = SequenceBuilder.new(ES::CharacterSequenceFrame)
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
    builder = PoseBuilder.new(ES::Pose.new(@default_options))
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

def calc_pose_index(col, row)
  col + row * 16
end

def render_generic_pose(cl, rw = 0)
  col = cl * 3
  row = rw * 5
  render_pose_list do |pb| # pb = pose_builder
    pb.default_options[:filename] = '4x/characters_4x.png'
    pb.default_options[:cell_width] = 32
    pb.default_options[:cell_height] = 32

    pb.pose 'idle' do |p|
      p.frame_rate = 2
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col, row + 4), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 12, 32, 20))
        s.incr(:index)
      end
    end
    pb.pose 'dead' do |p|
      p.frame_rate = 1
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col, row + 4), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 12, 32, 20))
      end
    end
    pb.pose 'stand.l' do |p|
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col, row + 2), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
      end
    end
    pb.pose 'stand.r' do |p|
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col, row + 0), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
      end
    end
    pb.pose 'stand.u' do |p|
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col, row + 3), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
      end
    end
    pb.pose 'stand.d' do |p|
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col, row + 1), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
      end
    end
    pb.pose 'walk.l' do |p|
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col + 1, row + 2), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
        s.incr(:index)
      end
    end
    pb.pose 'walk.r' do |p|
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col + 1, row + 0), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
        s.incr(:index)
      end
    end
    pb.pose 'walk.u' do |p|
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col + 1, row + 3), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
        s.incr(:index)
      end
    end
    pb.pose 'walk.d' do |p|
      p.setup_sequence do |s|
        s.keyframe(index: calc_pose_index(col + 1, row + 1), ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
        s.incr(:index)
      end
    end
  end
end

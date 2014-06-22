require_relative "base"

STDOUT.puts(YAML.dump(Character.new do |c|
  c.name = "baron"
  c.poses = render_pose_list do |pb| # pb = pose_builder
    pb.default_options[:filename] = "es-oryx/4x/character_4x.png"
    pb.default_options[:cell_width] = 32
    pb.default_options[:cell_height] = 32

    pb.pose "idle" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 12, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 12, 32, 20))
      end
    end
    pb.copy_pose "idle", "dead"
    pb.pose "stand.l" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 6, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
      end
    end
    pb.pose "stand.r" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 0, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
      end
    end
    pb.pose "stand.u" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 9, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
      end
    end
    pb.pose "stand.d" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 3, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
      end
    end
    pb.pose "walk.l" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 7, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
        s.incr(:index)
      end
    end
    pb.pose "walk.r" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 1, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
        s.incr(:index)
      end
    end
    pb.pose "walk.u" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 10, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
        s.incr(:index)
      end
    end
    pb.pose "walk.d" do |p|
      p.setup_sequence do |s|
        s.keyframe(index: 4, ox: 0, oy: 0, x: 0, y: 0,
                   bounding_box: Moon::Rect.new(0, 0, 32, 32))
        s.incr(:index)
      end
    end
  end
end.export))

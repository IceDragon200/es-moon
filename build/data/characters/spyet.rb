require_relative 'base'

pool(ES::Character.new do |c|
  c.name = 'spyet'
  c.uri = '/characters/spyet'
  c.poses = render_generic_pose(4)
end)

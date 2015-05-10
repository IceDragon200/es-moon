require_relative 'base'

pool(ES::Character.new do |c|
  c.name = 'cogan'
  c.uri = '/characters/cogan'
  c.poses = render_generic_pose(0, 1)
end)

require_relative 'base'

pool(ES::Character.new do |c|
  c.name = 'nixe'
  c.uri = '/characters/nixe'
  c.poses = render_generic_pose(2)
end)

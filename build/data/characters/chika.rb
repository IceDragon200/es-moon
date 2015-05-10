require_relative 'base'

pool(ES::Character.new do |c|
  c.name = 'chika'
  c.uri = '/characters/chika'
  c.poses = render_generic_pose(3)
end)

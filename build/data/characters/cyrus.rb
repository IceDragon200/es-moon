require_relative 'base'

pool(ES::Character.new do |c|
  c.name = 'cyrus'
  c.uri = '/characters/cyrus'
  c.poses = render_generic_pose(1, 1)
end)

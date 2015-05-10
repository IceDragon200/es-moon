require_relative 'base'

pool(ES::Character.new do |c|
  c.name = 'baron_w_backpack'
  c.uri = '/characters/baron+backpack'
  c.poses = render_generic_pose(0)
end)

pool(ES::Character.new do |c|
  c.name = 'baron'
  c.uri = '/characters/baron'
  c.poses = render_generic_pose(1)
end)

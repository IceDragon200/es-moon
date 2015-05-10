require_relative 'base'

pool(ES::Popup.new do |popup|
  popup.name = 'idling'
  popup.uri = 'popups/idling'
  popup.filename = 'lil-icons_3x.png'
  popup.cell_width = 30
  popup.cell_height = 30
  popup.frame_rate = 60 #16
  popup.sequence = render_popup_sequence do |builder|
    easer = Easing::CubicInOut
    rock = 28 #45
    bounce = 4
    builder.keyframe(index: 15, angle: 0, x: 0, y: -2, ox: popup.cell_width/2, oy: popup.cell_height*4/5)
    builder.tween_to(easer, 15, angle: rock, y: bounce)
    builder.tween_to(easer, 15, angle: 0, y: -2)
    builder.tween_to(easer, 15, angle: -rock, y: bounce)
    builder.tween_to(easer, 15, angle: 0, y: -2)
  end
end)

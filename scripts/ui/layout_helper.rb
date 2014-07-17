module LayoutHelper

  def self.align(str, rect, surface)
    commands = str.split(" ")
    commands.each do |command|
      case command
      when "center"
        rect.cx = surface.cx
        rect.cy = surface.cy
      when "middle-horz"
        rect.cx = surface.cx
      when "middle-vert"
        rect.cy = surface.cy
      when "left"
        rect.x = surface.x
      when "right"
        rect.x2 = surface.x2
      when "top"
        rect.y = surface.y
      when "bottom"
        rect.y2 = surface.y2
      end
    end
    rect
  end

end

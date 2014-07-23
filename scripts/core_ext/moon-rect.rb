module Moon
  class Rect
    def align(str, surface)
      rect = dup
      str.split(" ").each do |command|
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

    def contract(cx, cy=cx)
      cx = cx.to_i
      cy = cy.to_i
      Rect.new x + cx, y + cy, width - cx * 2, height - cy * 2
    end

    def cx
      x + width / 2
    end

    def cy
      y + height / 2
    end

    def cx=(cx)
      self.x = cx - width / 2
    end

    def cy=(cy)
      self.y = cy - height / 2
    end

    def inside?(obj)
      x, y = Vector2.extract(obj)
      x.between?(self.x, self.x2-1) && y.between?(self.y, self.y2-1)
    end

    def clear
      self.x = 0
      self.y = 0
      self.w = 0
      self.h = 0
      self
    end
  end
end

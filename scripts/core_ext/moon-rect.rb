module Moon
  class Rect
    def contract(cx, cy=cx)
      cx = cx.to_i
      cy = cy.to_i
      Rect.new x + cx, y + cy, width - cx * 2, height - cy * 2
    end

    def cx=(cx)
      self.x = cx - width / 2
    end

    def cy=(cy)
      self.y = cy - height / 2
    end

    def inside?(obj)
      x, y = Vector2.extract(obj)
      x.between?(self.x, self.x2) && y.between?(self.y, self.y2)
    end
  end
end

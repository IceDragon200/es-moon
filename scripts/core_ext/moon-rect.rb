module Moon
  class Rect

    def contract(cx, cy=cx)
      cx = cx.to_i
      cy = cy.to_i
      Rect.new x + cx, y + cy, width - cx * 2, height - cy * 2
    end

  end
end
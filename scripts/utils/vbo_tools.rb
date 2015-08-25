module VboTools
  def self.rect_to_texrect(rect, texture)
    [ rect.x.to_f / texture.w, rect.y.to_f / texture.h,  # x, y,
      rect.w.to_f / texture.w, rect.h.to_f / texture.h ] # w, h
  end

  def self.fill_rect(vbo, rect, srcrect, texture, texr, color)
    xrun, xrem = rect.w.divmod(srcrect.w)
    yrun, yrem = rect.h.divmod(srcrect.h)
    yrun.times do |y|
      row = rect.y + y * srcrect.h
      xrun.times do |x|
        vbo.add_quad [rect.x + x * srcrect.w, row, srcrect.w, srcrect.h], texr, color
      end
      if xrem > 0
        r = texr.dup
        r[2] = xrem.to_f / texture.w
        vbo.add_quad [rect.x + srcrect.w * xrun, row, xrem, srcrect.h], r, color
      end
    end
    if yrem > 0
      r = texr.dup
      r[3] = yrem.to_f / texture.h
      row = rect.y + yrun * srcrect.h
      xrun.times do |x|
        vbo.add_quad [rect.x + x * srcrect.w, row, srcrect.w, yrem], r, color
      end
      if xrem > 0
        r = r.dup
        r[2] = xrem.to_f / texture.w
        col = rect.x + xrun * srcrect.w
        vbo.add_quad [col, row, xrem, yrem], r, color
      end
    end
  end

  def self.fill_windowskin_vbo(vbo, rect, texture, color, part_rects)
    x, y, w, h = *rect

    # these represent the numpad
    # 7 8 9
    #
    # 4 5 6
    #
    # 1 2 3
    q7r = part_rects[0]
    q8r = part_rects[1]
    q9r = part_rects[2]

    q4r = part_rects[3]
    q5r = part_rects[4]
    q6r = part_rects[5]

    q1r = part_rects[6]
    q2r = part_rects[7]
    q3r = part_rects[8]

    q7tr = rect_to_texrect(q7r, texture)
    q8tr = rect_to_texrect(q8r, texture)
    q9tr = rect_to_texrect(q9r, texture)
    q4tr = rect_to_texrect(q4r, texture)
    q5tr = rect_to_texrect(q5r, texture)
    q6tr = rect_to_texrect(q6r, texture)
    q1tr = rect_to_texrect(q1r, texture)
    q2tr = rect_to_texrect(q2r, texture)
    q3tr = rect_to_texrect(q3r, texture)

    # fill corners
    ## top left
    vbo.add_quad [rect.x, rect.y, q7r.w, q7r.h], q7tr, color

    ## top right
    vbo.add_quad [rect.x + rect.w - q9r.w, rect.y, q9r.w, q9r.h], q9tr, color

    ## bottom left
    vbo.add_quad [rect.x, rect.y + rect.h - q1r.h, q1r.w, q1r.h], q1tr, color

    ## bottom right
    vbo.add_quad [rect.x + rect.w - q3r.w, rect.y + rect.h - q3r.h, q3r.w, q3r.h], q3tr, color

    ## top run
    r = Moon::Rect.new rect.x + q7r.w, rect.y, rect.w - q7r.w - q9r.w, q8r.h
    fill_rect vbo, r, q8r, texture, q8tr, color

    ## bottom run
    r = Moon::Rect.new rect.x + q1r.w, rect.y + rect.h - q2r.h, rect.w - q1r.w - q3r.w, q2r.h
    fill_rect vbo, r, q2r, texture, q2tr, color

    ## left run
    r = Moon::Rect.new rect.x, rect.y + q7r.h, q4r.w, rect.h - q7r.h - q1r.h
    fill_rect vbo, r, q4r, texture, q4tr, color

    ## right run
    r = Moon::Rect.new rect.x + rect.w - q6r.w, rect.y + q9r.h, q6r.w, rect.h - q9r.h - q3r.h
    fill_rect vbo, r, q6r, texture, q6tr, color

    ## mid
    r = Moon::Rect.new rect.x + q4r.w, rect.y + q8r.h, rect.w - q4r.w - q6r.w, rect.h - q8r.h - q2r.h
    fill_rect vbo, r, q5r, texture, q5tr, color
  end
end

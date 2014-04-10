ES::Database.create :chunk do |chunk|

  chunk.name = "school_f1/baron.room"
  chunk.data = DataMatrix.new(10, 10, 2) do |dm|
    painter = ES::Helper::PaintMap.new(dm)
    painter.save do |pnt|
      # contract
      pnt.clear
      pnt.set_layer(0)
      pnt.rect.contract(1)
      pnt.set_value(0).stroke
      pnt.set_value(12).fill
      pnt.set_layer(1).clear
    end
    painter.render
  end

end
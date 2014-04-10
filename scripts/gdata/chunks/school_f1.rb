ES::Database.create :chunk do |chunk|

  chunk.name = "school_f1/baron.room"
  chunk.data = DataMatrix.new(10, 10, 1) do |dm|
    dm.fill(-1)
    painter = ES::Helper::PaintMap.new(dm)

    painter.save do |pnt|
      # contract
      pnt.set_layer(0)
      pnt.rect.contract(1)
      pnt.set_value(0).stroke
      pnt.set_value(12).fill
    end
    painter.render
  end

end
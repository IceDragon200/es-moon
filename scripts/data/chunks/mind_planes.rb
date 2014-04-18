ES::Database.create :chunk do |chunk|

  chunk.name = "mind_plane/baron-arc1"

  chunk.data = DataMatrix.new(10, 10, 2) do |dm| dm.clear(-1)
    pnt = ES::Helper::PaintMap.new(dm)
  end

  chunk.flags = DataMatrix.new(*chunk.data.size) do |dm|
    dm.clear(Tilemap::DataFlag::NONE)
  end

  chunk.passages = Table.new(*chunk.data.size.xy) do |table| table.clear(0)
  end

end
ES::Database.create :chunk do |chunk|

  chunk.name = "school_f1/baron.room"

  chunk.data = DataMatrix.new(8, 6, 2) do |dm| dm.clear(-1)
    pnt = ES::Helper::PaintMap.new(dm)
    ### Ground layer                                           #
    pnt.layer = 0
    pnt.clear                                                  #
    pnt.fill(value: 12)                                        # floor
    pnt.stroke(value: 0, weight: 1, rect: dm.rect.contract(1)) # walls
    pnt.fill(value: 60, rect: [3, 2, 3, 3])                    # rug
    pnt[2, 0] = 1                                              # wall lamp
    pnt[5, 0] = 1                                              # wall lamp
    pnt[0, 3] = 12                                             # doorway
    ### Detail layer                                           #
    pnt.layer = 1
    pnt.clear                                                  #
    pnt[1, 1] = 135                                            # bed
    pnt[4, 1] = 141                                            # bookshelf
    pnt[4, 3] = 140                                            # table
    pnt[3, 3] = 138                                            # left chair
    pnt[5, 3] = 137                                            # right chair
  end

  chunk.flags = DataMatrix.new(*chunk.data.size) do |dm|
    dm.clear(Tilemap::DataFlag::NONE)
    # shift the bed a quater tile up
    dm[1, 1, 1] = Tilemap::DataFlag::QUART_OFF_TILE |
                  Tilemap::DataFlag::OFF_DOWN

    # we shift that bookshelf a half tile upwards so it looks like its
    # against the wall instead of off the wall
    dm[4, 1, 1] = Tilemap::DataFlag::HALF_OFF_TILE |
                  Tilemap::DataFlag::OFF_UP
  end

  chunk.passages = Table.new(*chunk.data.size.xy) do |table| table.clear(0)
    pss = "xxxxxxxx" +
          "xoooooox" +
          "xoooooox" +
          "ooooxoox" +
          "xoooooox" +
          "xxxxxxxx"
    table.set_from_strmap(pss, ES::Passage::STRMAP)
  end

end
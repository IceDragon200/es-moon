ES::Database.create :chunk do |chunk|

  chunk.name = "school_f1/baron.room"

  chunk.data = DataMatrix.new(8, 6, 2) do |dm| dm.clear(-1)
    painter = ES::Helper::PaintMap.new(dm)
    painter.save do |pnt|
      ## Ground layer                               #
      pnt.set_layer( 0).clear                       # ground layer
      pnt.rect.contract( 1)                         # inner
      pnt.set_value( 0).stroke                      # walls
      pnt.set_value( 12).fill                       # fill floor
      pnt.set_rect(3, 2, 3, 3).set_value( 60).fill  # fill rug
      pnt.reset_rect                                # restore rect
      pnt.set_pos( 2,  0).set_value( 1).point       # wall lamp
      pnt.move( 3,  0).set_value( 1).point          # wall lamp
      pnt.set_pos( 0,  3).set_value( 12).point      # doorway
      ## Detail layer                               #
      pnt.set_pos( 0,  0).set_layer( 1).clear       # goto second layer
      pnt.move( 1,  1).set_value( 135).point        # bed
      pnt.move( 3,  0).set_value( 141).point        # bookshelf
      pnt.move( 0,  2).set_value( 140).point        # table
      pnt.move(-1,  0).set_value( 138).point        # left chair
      pnt.move( 2,  0).set_value( 137).point        # right chair
    end
    painter.render
  end

  chunk.flags = DataMatrix.new(*chunk.data.size) do |dm|
    dm.clear(Tilemap::DataFlag::NONE)
    painter = ES::Helper::PaintMap.new(dm)
    painter.save do |pnt|
      pnt.set_layer( 1)
      # shift the bed a quater tile up
      pnt.set_pos(1, 1).set_value(Tilemap::DataFlag::QUART_OFF_TILE |
                                  Tilemap::DataFlag::OFF_DOWN).point

      # we shift that bookshelf a half tile upwards so it looks like its
      # against the wall instead of off the wall
      pnt.set_pos(4, 1).set_value(Tilemap::DataFlag::HALF_OFF_TILE |
                                  Tilemap::DataFlag::OFF_UP).point
    end
    painter.render
  end

  chunk.passage = Table.new(*chunk.data.size.xy) do |table| table.clear(0)
    pss = "xxxxxxxx" +
          "xoooooox" +
          "xoooooox" +
          "ooooxoox" +
          "xoooooox" +
          "xxxxxxxx"
    table.set_from_strmap(pss, ES::Passage::STRMAP)
  end

end
tileset = {
  uri: "/tilesets/common"
}

pool(ES::Chunk.new do |chunk|
  chunk.name = "Baron's School Room"
  chunk.uri = "/chunks/school/f1/room/baron"

  chunk.tileset.update_fields(tileset)

  chunk.data = DataMatrix.new(8, 6, 2, default: -1) do |dm|
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

  chunk.passages = Table.new(*chunk.data.size.xy) do |table| table.clear(0)
    pss = "xxxxxxxx" +
          "xoooooox" +
          "xoooooox" +
          "ooooxoox" +
          "xoooooox" +
          "xxxxxxxx"
    table.set_from_strmap(pss, ES::Passage::STRMAP)
  end
end)

pool(ES::Chunk.new do |chunk|
  chunk.name = "School F1 Hallway"
  chunk.uri = "/chunks/school/f1/hallway"

  chunk.tileset.update_fields(tileset)

  chunk.data = DataMatrix.new(7, 12, 2) do |dm| dm.clear(-1)
    dm.default = -1

    pnt = ES::Helper::PaintMap.new(dm)
    pnt.layer = 0
    pnt.clear                                                  #
    pnt.fill(value: 12, rect: dm.rect.contract(2, 0))          # floor
    pnt.stroke(value: 0, rect: dm.rect.contract(2, 0))         # wall
    pnt[6, 2] = 1                                              # lamp
    pnt[6, 4] = 1                                              # lamp
    pnt[5, 3] = 12                                             # walkway
    pnt[6, 3] = 12                                             # walkway
    pnt.layer = 1
  end

  chunk.passages = Table.new(*chunk.data.size.xy) do |table| table.clear(0)
    pss = "xxxxxxx" +
          "xxoooxx" +
          "xxoooxx" +
          "xxooooo" +
          "xxoooxx" +
          "xxoooxx" +
          "xxoooxx" +
          "xxoooxx" +
          "xxoooxx" +
          "xxoooxx" +
          "xxoooxx" +
          "xxxxxxx"
    table.set_from_strmap(pss, ES::Passage::STRMAP)
  end
end)

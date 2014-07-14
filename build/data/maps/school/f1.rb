pool(ES::DataModel::Map.new do |map|

  map.name = "School F1"
  map.uri = "/maps/school/f1"

  map.chunks.push ES::DataModel::ChunkHead.new(uri: "/chunks/school/f1/hallway", position: Vector3.new(0,0,0))
  map.chunks.push ES::DataModel::ChunkHead.new(uri: "/chunks/school/f1/room/baron", position: Vector3.new(7,0,0))

end)

ES::Database.create :map do |map|

  map.name = "school_f1"

  map.chunks.push name: "school_f1/hallway"
  map.chunk_position.push Vector3.new 0, 0, 0

  map.chunks.push name: "school_f1/room.baron"
  map.chunk_position.push Vector3.new 7, 0, 0

end
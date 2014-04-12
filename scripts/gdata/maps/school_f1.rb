ES::Database.create :map do |map|

  map.name = "school_f1"
  map.chunks.push name: "school_f1/baron.room"
  map.chunk_position.push Vector3.new 0, 0, 0

  ##
  # just a test to see if multiple chunks work properly
  #map.chunks.push name: "school_f1/baron.room"
  #map.chunk_position.push Vector3.new 0, 9, 0

end
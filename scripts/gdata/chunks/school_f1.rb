ES::Database.create :chunk do |chunk|
  chunk.name = "school_f1/baron.room"
  chunk.data = DataMatrix.new(10, 10, 1) do |dm|
    dm
  end
end
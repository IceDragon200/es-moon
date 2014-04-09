ES::Database.create :chunk do |chunk|

  chunk.name = "school_f1/baron.room"
  chunk.data = DataMatrix.new(10, 10, 2) do |dm|
    dm.fill(-1) # clear
    dm[0, 0, 0] = 20
    dm[9, 0, 0] = 22
    dm[0, 9, 0] = 40
    dm[9, 9, 0] = 42
  end

end
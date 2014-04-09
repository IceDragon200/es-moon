ES::Database.create :chunk do |chunk|

  chunk.name = "school_f1/baron.room"
  chunk.data = DataMatrix.new(10, 10, 2) do |dm|
    dm.fill(-1) # clear
    dm[0, 0, 0] = 20
    (1..8).each { |x| dm[x, 0, 0] = 21 }
    dm[9, 0, 0] = 22
    (1..8).each do |y|
      dm[0, y, 0] = 30
      dm[9, y, 0] = 32
    end
    dm[0, 9, 0] = 40
    dm[9, 9, 0] = 42
    (1..8).each { |x| dm[x, 9, 0] = 21 }
  end

end
module Animation
  class Stepper
    attr_reader :index
    attr_reader :length
    attr_reader :fps
    attr_reader :rate
    attr_reader :time

    def initialize(length, fps = nil)
      @length = length
      @index = 0
      @fps = fps || @length
      @time = 0.0
    end

    def update(delta)
      @index = (@length.to_f * @time.to_f / @fps).to_i % @length
      @rate = @index.to_f / @length
      @time += delta
    end
  end
end

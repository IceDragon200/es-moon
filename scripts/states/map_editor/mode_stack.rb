class ModeStack
  def initialize
    @list = []
  end

  def current
    @list.last
  end

  def push(mode)
    @list.push mode
    puts @list
  end

  def change(mode)
    @list[-1] = mode
    puts @list
  end

  def pop
    @list.pop
    puts @list
  end

  def is?(mode)
    current == mode
  end

  def has?(mode)
    @list.include?(mode)
  end

  def starts_with?(*modes)
    modes.each_with_index.all? do |mode, i|
      @list[i] == mode
    end
  end

  def trace?(modes)
    @list == modes
  end

  def [](index)
    @list[index]
  end
end

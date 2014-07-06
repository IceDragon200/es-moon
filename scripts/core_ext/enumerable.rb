module Enumerable

  def count(obj)
    inject(0) { |r, e| r += 1 if e == obj; r }
  end unless method_defined? :count

end
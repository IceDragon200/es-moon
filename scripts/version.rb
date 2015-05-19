module ES
  module Version
    MAJOR, MINOR, TEENY, PATCH = 0, 2, 1, 'alpha'
    STRING = [MAJOR, MINOR, TEENY, PATCH].join('.')
  end
end

module ES
  module Version
    MAJOR, MINOR, TEENY, PATCH = 0, 2, 0, 'alpha'
    STRING = [MAJOR, MINOR, TEENY, PATCH].join('.')
  end
end

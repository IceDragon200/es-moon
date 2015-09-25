require 'spec_helper'
require 'scripts/controllers/text_input'

module Fixtures
  class TextObj
    attr_accessor :string

    def initialize
      @string = ''
    end
  end
end

describe Controllers::TextInput do
  context '#initialize' do
    it 'initializes a TextInput controller' do
      text = TextObj.new
      text_input = described_class.new(text)
    end
  end
end

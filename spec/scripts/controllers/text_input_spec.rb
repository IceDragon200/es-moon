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
      text = Fixtures::TextObj.new
      text_input = described_class.new(text)
    end
  end

  context 'string manipulation' do
    let(:text_input) do
      @text_input ||= begin
        text = Fixtures::TextObj.new
        described_class.new(text)
      end
    end

    context '#insert' do
      context 'append mode' do
        it 'inserts a string' do
          text_input.mode = :append
          text_input.insert('abc')
          expect(text_input.target.string).to eq('abc')
        end

        it 'will append a string if the index is reset' do
          text_input.target.string = 'abc'
          text_input.mode = :append
          text_input.index = 0
          text_input.insert('_def')
          expect(text_input.target.string).to eq('_defabc')
        end

        it 'will insert a string if the index is inside the string' do
          text_input.target.string = '_defabc'
          text_input.mode = :append
          text_input.index = 4
          text_input.insert('-0_0-')
          expect(text_input.target.string).to eq('_def-0_0-abc')
        end
      end

      context 'replace mode' do
        it 'replaces the contents of the string' do
          text_input.mode = :replace

          text_input.target.string = '_def-0_0-abc'
          text_input.index = 0
          text_input.insert('defa')
          expect(text_input.target.string).to eq('defa-0_0-abc')

          text_input.index = 4
          text_input.insert('1234')
          expect(text_input.target.string).to eq('defa1234-abc')

          # works like append if at the end of the string
          text_input.index = text_input.target.string.size
          text_input.insert('-end')
          expect(text_input.target.string).to eq('defa1234-abc-end')
        end
      end
    end

    context '#backspace' do
      it 'erases a character left of the cursor' do
        text_input.target.string = 'abdc'
        text_input.index = 3
        text_input.backspace
        expect(text_input.target.string).to eq('abc')
      end
    end

    context '#delete' do
      it 'erases a character right of the cursor' do
        text_input.target.string = 'abdc'
        text_input.index = 2
        text_input.delete
        expect(text_input.target.string).to eq('abc')
      end
    end

    context '#cursor_(prev|next)' do
      it 'moves the index' do
        text_input.target.string = 'abcd'
        text_input.index = 0

        # should be clamped
        text_input.cursor_prev
        expect(text_input.index).to eq(0)


        text_input.cursor_next
        expect(text_input.index).to eq(1)
      end
    end
  end
end

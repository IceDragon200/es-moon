require 'spec_helper'
require 'scripts/core/color'

describe Color do
  context '.rgba' do
    it 'creates a Vector4 from the given RGBA32 values' do
      v = described_class.rgba(255, 255, 255, 255)
      expect(v).to eq(Moon::Vector4[1, 1, 1, 1])
    end
  end

  context '.rgb' do
    it 'creates a Vector4 from the given RGB24 values' do
      v = described_class.rgb(255, 255, 255)
      expect(v).to eq(Moon::Vector4[1, 1, 1, 1])

      v = described_class.rgb(0, 0, 0)
      expect(v).to eq(Moon::Vector4[0, 0, 0, 1])
    end
  end

  context '.mono' do
    it 'creates a Vector4 from the given gray value' do
      v = described_class.mono(255)
      expect(v).to eq(Moon::Vector4[1, 1, 1, 1])

      v = described_class.mono(0)
      expect(v).to eq(Moon::Vector4[0, 0, 0, 1])

      v = described_class.mono(128)
      expect(v.round(1)).to eq(Moon::Vector4[0.5, 0.5, 0.5, 1])
    end
  end

  context '.hex' do
    it 'creates a Vector4 from a 24 bit HEX value' do
      v = described_class.hex(0xFFFFFF)
      expect(v).to eq(Moon::Vector4[1, 1, 1, 1])

      v = described_class.hex(0x000000)
      expect(v).to eq(Moon::Vector4[0, 0, 0, 1])

      v = described_class.hex(0xFF8000)
      expect(v.round(1)).to eq(Moon::Vector4[1, 0.5, 0, 1])
    end
  end
end

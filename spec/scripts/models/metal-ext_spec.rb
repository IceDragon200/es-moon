require 'data_model/metal'
require 'scripts/models/metal-ext'
require 'scripts/models/base'
require 'tmpdir'

describe Moon::DataModel::Metal do
  context '#save_file' do
    it 'saves a model file' do
      model = Models::Base.new(id: 'test/model')
      Dir.mktmpdir do |d|
        model.save_file(d)

        expect(File.exist?(File.join(d, 'data/test/model.yml'))).to eq(true)
      end
    end
  end
end

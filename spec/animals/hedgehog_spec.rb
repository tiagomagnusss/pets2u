require_relative '../../animals/hedgehog'
require 'spec_helper'

describe Animals::Hedgehog do
  describe '#size' do
    it 'returns the area it occupies' do
      expect(subject.size).to eq(400)
    end
  end
end

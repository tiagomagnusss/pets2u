require_relative '../../animals/mongoose'
require 'spec_helper'

describe Animals::Mongoose do
  describe '#size' do
    it 'returns the area it occupies' do
      expect(subject.size).to eq(800)
    end
  end
end

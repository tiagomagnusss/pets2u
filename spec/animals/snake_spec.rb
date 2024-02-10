require_relative '../../animals/snake'
require 'spec_helper'

describe Animals::Snake do
  describe '#size' do
    it 'returns the area it occupies' do
      expect(subject.size).to eq(1200)
    end
  end
end

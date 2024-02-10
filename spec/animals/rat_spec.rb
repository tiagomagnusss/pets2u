require_relative '../../animals/rat'
require 'spec_helper'

describe Animals::Rat do
  describe '#size' do
    it 'returns the area it occupies' do
      expect(subject.size).to eq(400)
    end
  end
end

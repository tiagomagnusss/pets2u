require_relative '../../boxes/b2'
require 'spec_helper'

describe Boxes::B2 do
  describe '#space' do
    it 'returns the area space it has' do
      expect(subject.space).to eq(800)
    end
  end
end

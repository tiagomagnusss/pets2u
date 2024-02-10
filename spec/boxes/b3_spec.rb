require_relative '../../boxes/b3'
require 'spec_helper'

describe Boxes::B3 do
  describe '#space' do
    it 'returns the area space it has' do
      expect(subject.space).to eq(1600)
    end
  end
end

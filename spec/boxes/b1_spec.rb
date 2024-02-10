require_relative '../../boxes/b1'
require 'spec_helper'

describe Boxes::B1 do
  describe '#space' do
    it 'returns the area space it has' do
      expect(subject.space).to eq(400)
    end
  end
end

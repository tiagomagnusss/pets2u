require_relative '../boxes'
require_relative '../boxes/b1'
require 'spec_helper'

describe Boxes::Box do
  describe '#fit?' do
    it 'returns true if the animal fits in the box' do
      box = Boxes::B1.new
      animal = double('animal', size: 100)

      expect(box.fit?(animal)).to be true
    end

    it 'returns false if the animal does not fit in the box' do
      box = Boxes::B1.new
      animal = double('animal', size: 1000)

      expect(box.fit?(animal)).to be false
    end
  end

  describe '#insert' do
    it 'reduces the space in the box by the size of the animal' do
      box = Boxes::B1.new
      original_space = box.space
      animal = double('animal', size: 100)
      box.insert(animal)

      expect(box.space).to eq(original_space - 100)
    end

    it 'raises an error if the animal does not fit in the box' do
      box = Boxes::B1.new
      animal = double('animal', size: 1000)

      expect { box.insert(animal) }.to raise_error(Boxes::AnimalDoesNotFitError)
    end
  end

  describe '#name' do
    it 'returns the name of the box' do
      box = Boxes::B1.new
      expect(box.name).to eq('B1')
    end
  end
end

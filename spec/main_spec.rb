require_relative '../main'
require 'spec_helper'

describe IOManager do
  describe "#get_input" do
    it "returns an array of strings" do
      instance = IOManager.new
      allow(instance).to receive(:gets).and_return('R, H, M, S')

      expect(instance.get_input).to eq(["R", "H", "M", "S"])
    end
  end

  describe "#display_output" do
    it "displays the names of the boxes" do
      instance = IOManager.new
      boxes = {
        B1: [Boxes::B1.new],
        B2: [Boxes::B2.new],
        B3: [Boxes::B3.new]
      }

      expect { instance.display_output(boxes) }.to output("B1, B2, B3\n").to_stdout
    end
  end
end

describe Main do
  describe "#run" do
    context 'when the input is invalid' do
      it 'raises an error' do
        instance = Main.new

        io_manager = instance.instance_variable_get(:@io)
        allow(io_manager).to receive(:gets).and_return('R, H, M, X')

        expect { instance.run }.to raise_error(RuntimeError, 'Invalid animal type: X. Valid values are R, H, M, or S.')
      end
    end

    context 'when given a valid input' do
      it 'correctly organizes the animals R' do
        expect_animals_to_be_in_boxes('R', ['B1'])
      end

      it 'correctly organizes the animals H' do
        expect_animals_to_be_in_boxes('H', ['B1'])
      end

      it 'correctly organizes the animals M' do
        expect_animals_to_be_in_boxes('M', ['B2'])
      end

      it 'correctly organizes the animals S' do
        expect_animals_to_be_in_boxes('S', ['B3'])
      end

      it 'correctly organizes the animals R, H, H' do
        expect_animals_to_be_in_boxes('R, H, H', ['B3'])
      end

      it 'correctly organizes the animals S, M' do
        expect_animals_to_be_in_boxes('S, M', ['B2', 'B3'])
      end

      it 'correctly organizes the animals S, H, R, M' do
        expect_animals_to_be_in_boxes('S, H, R, M', ['B3', 'B3'])
      end

      it 'correctly organizes the animals R, H, S' do
        expect_animals_to_be_in_boxes('R, H, S', ['B1', 'B3'])
      end

      it 'correctly organizes the animals S, R, S, H, M, M' do
        expect_animals_to_be_in_boxes('S, R, S, H, M, M', ['B3', 'B3', 'B3'])
      end

      it 'correctly organizes the animals S, S, S, S, S, S' do
        expect_animals_to_be_in_boxes('S, S, S, S, S, S', 6.times.map { 'B3' })
      end

      it 'correctly organizes the animals R, R, R, R, R, R' do
        expect_animals_to_be_in_boxes('R, R, R, R, R, R', ['B2', 'B3'])
      end
    end
  end

  describe "#parse_animals" do
    it "fills the animals list with an array of matching animals" do
      instance = Main.new
      input_animals = ["R", "H", "M", "S"]

      instance.send(:parse_animals, input_animals)
      expect(
        instance.instance_variable_get(:@animals).map(&:class).map(&:name)
      ).to match_array(
        ['Animals::Rat', 'Animals::Hedgehog', 'Animals::Mongoose', 'Animals::Snake']
      )
    end
  end

  describe "#order_animals_by_size" do
    it "sorts the animals list by size" do
      instance = Main.new
      instance.instance_variable_set(:@animals, [
        Animals::Rat.new,
        Animals::Hedgehog.new,
        Animals::Mongoose.new,
        Animals::Snake.new
      ])

      instance.send(:order_animals_by_size)
      expect(
        instance.instance_variable_get(:@animals).map(&:class).map(&:name)
      ).to eq(
        ['Animals::Snake', 'Animals::Mongoose', 'Animals::Rat', 'Animals::Hedgehog']
      )
    end
  end

  describe "#prefill_boxes" do
    it "fills the boxes with animals" do
      instance = Main.new
      instance.instance_variable_set(:@animals, [
        Animals::Rat.new,
        Animals::Hedgehog.new,
        Animals::Mongoose.new,
      ])

      instance.send(:order_animals_by_size)
      instance.send(:prefill_boxes)

      expect(
        instance.instance_variable_get(:@boxes).map { |key, value| value.map(&:name) }
      ).to eq(
        [['B1', 'B1'], ['B2'], []]
      )
    end

    context 'when adding rat or hedgehog' do
      context 'when there is a snake in a box' do
        it 'adds the rat or hedgehog to the same box' do
          instance = Main.new
          instance.instance_variable_set(:@animals, [
            Animals::Rat.new,
            Animals::Hedgehog.new,
            Animals::Snake.new,
          ])

          instance.send(:order_animals_by_size)
          instance.send(:prefill_boxes)

          expect(
            instance.instance_variable_get(:@boxes).map { |key, value| value.map(&:name) }
          ).to eq(
            [['B1'], [], ['B3']]
          )
        end
      end

      context 'when there is no snake in a box' do
        it 'adds the rat or hedgehog to the same box' do
          instance = Main.new
          instance.instance_variable_set(:@animals, [
            Animals::Rat.new,
            Animals::Hedgehog.new,
            Animals::Mongoose.new,
          ])

          instance.send(:order_animals_by_size)
          instance.send(:prefill_boxes)

          expect(
            instance.instance_variable_get(:@boxes).map { |key, value| value.map(&:name) }
          ).to eq(
            [['B1', 'B1'], ['B2'], []]
          )
        end
      end
    end
  end

  describe "#merge_b1_boxes" do
    it "merges the b1 boxes" do
      instance = Main.new
      instance.instance_variable_set(:@boxes, {
        B1: [Boxes::B1.new, Boxes::B1.new],
        B2: [Boxes::B2.new],
        B3: []
      })

      instance.send(:merge_b1_boxes)

      expect(
        instance.instance_variable_get(:@boxes).map { |key, value| value.map(&:name) }
      ).to eq(
        [[], ['B2', 'B2'], []]
      )
    end

    it 'does not touch the b1 boxes if there is only one' do
      instance = Main.new
      instance.instance_variable_set(:@boxes, {
        B1: [Boxes::B1.new],
        B2: [Boxes::B2.new],
        B3: []
      })

      instance.send(:merge_b1_boxes)

      expect(
        instance.instance_variable_get(:@boxes).map { |key, value| value.map(&:name) }
      ).to eq(
        [['B1'], ['B2'], []]
      )
    end
  end

  describe '#merge_b2_boxes' do
    it 'merges the b2 boxes' do
      instance = Main.new
      instance.instance_variable_set(:@boxes, {
        B1: [],
        B2: [Boxes::B2.new, Boxes::B2.new],
        B3: []
      })

      instance.send(:merge_b2_boxes)

      expect(
        instance.instance_variable_get(:@boxes).map { |key, value| value.map(&:name) }
      ).to eq(
        [[], [], ['B3']]
      )
    end

    it 'does not touch the b2 boxes if there is only one' do
      instance = Main.new
      instance.instance_variable_set(:@boxes, {
        B1: [],
        B2: [Boxes::B2.new],
        B3: []
      })

      instance.send(:merge_b2_boxes)

      expect(
        instance.instance_variable_get(:@boxes).map { |key, value| value.map(&:name) }
      ).to eq(
        [[], ['B2'], []]
      )
    end
  end

  describe '#merge_b1_and_b2_boxes' do
    it 'merges the b1 and b2 boxes' do
      instance = Main.new
      instance.instance_variable_set(:@boxes, {
        B1: [Boxes::B1.new],
        B2: [Boxes::B2.new],
        B3: []
      })

      instance.send(:merge_b1_and_b2_boxes)

      expect(
        instance.instance_variable_get(:@boxes).map { |key, value| value.map(&:name) }
      ).to eq(
        [[], [], ['B3']]
      )
    end
  end

  describe '#merge_boxes' do
    it 'calls the merge methods' do
      instance = Main.new
      allow(instance).to receive(:merge_b1_boxes)
      allow(instance).to receive(:merge_b2_boxes)
      allow(instance).to receive(:merge_b1_and_b2_boxes)

      instance.send(:merge_boxes)

      expect(instance).to have_received(:merge_b1_boxes)
      expect(instance).to have_received(:merge_b2_boxes)
      expect(instance).to have_received(:merge_b1_and_b2_boxes)
    end
  end

  def expect_animals_to_be_in_boxes(animals, boxes)
    instance = Main.new

    io_manager = instance.instance_variable_get(:@io)
    allow(io_manager).to receive(:gets).and_return(animals)

    expect { instance.run }.to output("#{boxes.join(', ')}\n").to_stdout
  end
end
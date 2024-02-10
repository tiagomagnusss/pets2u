### Pets2U coding problem - 2024-02-12

# Requiring modules and classes
Dir[File.join(__dir__, "/animals/**/*.rb"), File.join(__dir__, "/boxes/**/*.rb")].each do |file|
  require file
end

class IOManager
  def get_input
    input = gets.chomp
    input.upcase.gsub(/\s+/, "").split(",")
  end

  def display_output(boxes)
    puts boxes.map { |key, value| value.map(&:name) }.flatten.join(", ")
  end
end

class Main
  def initialize
    @io = IOManager.new
    @boxes = { B1: [], B2: [], B3: [] }
    @animals = []
  end

  def run
    input_animals = @io.get_input

    parse_animals(input_animals)
    prefill_boxes
    merge_boxes

    @io.display_output(@boxes)
  end

  private

  def parse_animals(input_animals)
    input_animals.each do |animal|
      case animal
      when "R"
        @animals << Animals::Rat.new
      when "H"
        @animals << Animals::Hedgehog.new
      when "M"
        @animals << Animals::Mongoose.new
      when "S"
        @animals << Animals::Snake.new
      else
        raise "Invalid animal type: #{animal}. Valid values are R, H, M, or S."
      end
    end
  end

  def order_animals_by_size
    @animals.sort_by! { |animal| animal.size }.reverse!
  end

  def prefill_boxes
    order_animals_by_size

    @animals.each do |animal|
      if animal.is_a?(Animals::Snake)
        box = Boxes::B3.new
      elsif animal.is_a?(Animals::Mongoose)
        box = Boxes::B2.new
      elsif animal.is_a?(Animals::Hedgehog) || animal.is_a?(Animals::Rat)
        # PS: I strongly advise against putting a rat or a hedgehog in a box with a snake! :)
        existing_box = @boxes[:B3].find { |box| box.fit? animal }

        if existing_box
          existing_box.insert animal
          next
        end

        box = Boxes::B1.new
      end

      box.insert animal
      @boxes[box.name.to_sym] << box
    end
  end

  def merge_boxes_from_to(box_type, next_box_type)
    box_count = @boxes[box_type].size
    mergeable = (box_count / 2).floor

    @boxes[box_type].pop(mergeable * 2)

    mergeable.times do
      @boxes[next_box_type] << Object.const_get("Boxes::#{next_box_type}").new
    end
  end

  def merge_b1_and_b2_boxes
    if @boxes[:B1].size == 1 && @boxes[:B2].size == 1
      @boxes[:B1].pop
      @boxes[:B2].pop
      @boxes[:B3] << Boxes::B3.new
    end
  end

  def merge_boxes
    merge_boxes_from_to(:B1, :B2)
    merge_boxes_from_to(:B2, :B3)
    merge_b1_and_b2_boxes
  end
end

if __FILE__ == $0
  main = Main.new
  main.run
end

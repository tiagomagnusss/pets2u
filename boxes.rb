module Boxes
  class Box
    attr_reader :space

    def fit?(animal)
      animal.size <= @space
    end

    def insert(animal)
      if fit?(animal)
        @space -= animal.size
      else
        raise AnimalDoesNotFitError
      end
    end

    def name
      self.class.name.split('::').last
    end
  end

  class AnimalDoesNotFitError < StandardError
  end
end


require_relative '../boxes'

module Boxes
  class B3 < Boxes::Box
    def initialize
      # 40 * 40
      @space = 1600
    end
  end
end

require_relative '../boxes'

module Boxes
  class B1 < Boxes::Box
    def initialize
      # 20 * 20
      @space = 400
    end
  end
end

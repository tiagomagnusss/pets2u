require_relative '../boxes'

module Boxes
  class B2 < Boxes::Box
    def initialize
      # 40 * 20
      @space = 800
    end
  end
end

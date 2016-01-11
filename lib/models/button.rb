module Gol2
  class Button < Gol2::UIBase
    attr_accessor :image_up, :image_down, :image_hover

    def initialize(options = nil)
      super
      self.color_hover = "#ffeeeeee"
      self.color_up = "#ffeeeeee"
      self.color_down = "#ffeeeeee"
    end
    #
    # ui state
    # returns alpha value
    #
    def hover_state
      self.color_hover
    end

    def up_state
      self.color_up
    end

    def down_state
      self.color_down
    end
  end
end
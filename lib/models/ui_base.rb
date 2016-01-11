require 'gosu'

module Gol2
  class UIBase
    attr_accessor :x_loc, :y_loc, :width, :height,
                  :primary_color, :up_color, :down_color, :hover_color,
                  :ui_options

    DefaultOptions = {
        x: 0, y: 0, w: 100, h: 40, c: 0xffffffff
    }

    def initialize(options = {})
      self.ui_options = DefaultOptions.merge(options)
      self.x_loc = ui_options[:x]
      self.y_loc = ui_options[:y]
      self.width = ui_options[:w]
      self.height = ui_options[:h]
      self.primary_color = self.ui_options[:c]

    end

    def contains?(x, y)
      x >= self.x_loc && x <= (self.x_loc + self.width) && y >= self.y_loc && y <= (self.y_loc + self.height)
    end

    #
    # ui state
    # returns alpha value
    #
    def hover_state
      if !self.hover_color
        self.hover_color = Gosu::Color.argb(self.primary_color)
        self.hover_color.value *= 0.80
        self.hover_color.saturation *= 0.80
      end
      self.hover_color
    end

    def up_state
      self.up_color ||= Gosu::Color.argb(self.primary_color)
    end

    def down_state
      if !self.down_color
        self.down_color = Gosu::Color.argb(self.primary_color)
        self.down_color.value *= 0.60
        self.down_color.saturation *= 0.60
      end
      self.down_color
    end

  end
end
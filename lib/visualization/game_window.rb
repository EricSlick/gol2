require 'gosu'

module Gol2
  class GameWindow < Gosu::Window
    attr_accessor :shutdown, :exit_code

    def initialize(width = 640, height = 480)
      super width, height
      self.caption = "Gosu Tutorial Game"
    end

    def controlled_shutdown
      self.exit_code = 1
      close
    end

    def update
      controlled_shutdown if shutdown
    end

    def draw
    end
  end
end

module Gol2
  class Game
    class << self
      attr_accessor :testing
    end

    attr_accessor :game_window

    def run
      unless Gol2::Game.testing
        game_window = Gol2::GameWindow.new
        game_window.shutdown = true
        game_window.show
      end
    end
  end
end
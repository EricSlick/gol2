require 'gosu'

module Gol2
  class GameWindow < Gosu::Window
    attr_accessor :shutdown, :shutdown_in, :shutdown_at_generation, :exit_code, :custom_options,
                  :game_loop, :game_clock, :update_clock, :delta_time, :last_time, :shutdown_time,
                  :point_size, :scale, :cell_size,
                  :game_width, :game_height, :game_window_width, :game_window_height,
                  :window_width, :window_height, :ui_width, :ui_height


    UPDATE_DELAY = 1000

    ZOrderGameUI = 1
    ZOrderGame = 2
    ZOrderGameBackground = 3
    ZOrderWindowUI = 4

    def initialize(options = {})
      self.custom_options = options
      update_settings
      super self.window_width, self.window_height, false

      #@font = Gosu::Font.new(self, Gosu::default_font_name, 18)
      @font = Gosu::Font.new(20)
      # @font = Gosu::Font.new(self, "Arial", 18)

      self.game_loop = 0
      self.caption = "Game of Life 2"
      self.game_clock = 0
      self.delta_time = 0
      self.update_clock = 0
      self.last_time = 0
    end

    def update_settings
      self.shutdown_in = self.custom_options[:shutdown_in]
      self.shutdown_at_generation = self.custom_options[:shutdown_at_generation]
      self.game_width = Gol2::GameController.game_width
      self.game_height = Gol2::GameController.game_height
      self.point_size = Gol2::GameController.cell_size

      self.game_window_width = self.game_width * self.point_size
      self.game_window_height = self.game_height * self.point_size

      # todo: handle UI specifications more dynamically
      self.ui_width = 100
      self.ui_height = 80
      self.window_width = self.game_window_width + self.ui_width
      self.window_height = self.game_window_height + self.ui_height
    end

    def controlled_shutdown
      self.exit_code = 1
      self.shutdown_time = Time.now
      close
    end

    def check_shutdown
      controlled_shutdown if shutdown
      if shutdown_in
        controlled_shutdown if shutdown_in < self.game_clock
      end
    end

    def update
      self.delta_time = Gosu::milliseconds - self.last_time
      self.last_time = Gosu::milliseconds
      check_shutdown
      if !@paused
        self.game_clock += self.delta_time
        if self.game_clock >= self.update_clock
          self.game_loop += 1
          Gol2::GameController.update_game unless @paused
          self.update_clock += UPDATE_DELAY
          controlled_shutdown if self.shutdown_at_generation && self.shutdown_at_generation == self.game_loop
          self.shutdown_in = self.delta_time + 10000 unless self.shutdown_in
        end
      end
    end

    def draw
      draw_cells
      # @font.draw("shutdown_in: #{self.shutdown_in}ms / #{self.game_clock}", 10, 10, ZOrderUI, 1.0, 1.0, 0xff_ffff00)
      @font.draw("game_loop: #{self.game_loop} ActiveCells: #{Gol2::GameController.get_active_cells.length}", 10, 10, ZOrderGameUI, 1.0, 1.0, 0xff_ffff00)
      @font.draw(@debug, 10, 35, ZOrderGameUI, 1.0, 1.0, 0xff_ffff00) if @debug
    end

    def draw_cells
      # game_height and width are not the same as game_window_height and width
      # game_height/width is used by the controller to handle the internal size of the game area
      # the game_window_width/height is modified to fit one point size per game_height/width
      # so, when drawing a cell, we have to take into account the visual size (point size) of the cell
      # a point size of 2 means a single game_height/width location of a cell takes up 4 pixels on the game_window

      Gol2::GameController.get_active_cells.each do |key, cell|
        draw_quad(cell.x_loc * self.point_size, cell.y_loc, 0xffffffff,
                  cell.x_loc * self.point_size + 2, cell.y_loc, 0xffffffff,
                  cell.x_loc * self.point_size, cell.y_loc + 2, 0xffffffff,
                  cell.x_loc * self.point_size + 2, cell.y_loc + 2, 0xffffffff,
                  0)
      end
    end

    def button_down(key_id)
      if key_id == Gosu::KbSpace then
        @paused = @paused != true
        @debug = "Spacebar was hit: paused: #{@paused}"
      end
    end
  end
end

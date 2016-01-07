require 'gosu'

module Gol2
  class GameWindow < Gosu::Window
    attr_accessor :shutdown, :shutdown_in, :shutdown_at_generation, :exit_code, :options,
                  :game_loop, :game_clock, :update_clock, :delta_time, :last_time, :shutdown_time,
                  :point_size, :scale, :game_width, :game_height, :game_window_width, :game_window_height,
                  :window_width, :window_height


    UPDATE_DELAY = 1000

    ZOrderGameUI = 1
    ZOrderGame = 2
    ZOrderGameBackground = 3
    ZOrderWindowUI = 4

    DEFAULTS = {
        game_window_width: 640,
        game_window_height: 480,
        scale: 1
    }

    def initialize(custom_options = {})
      self.options = DEFAULTS.merge(custom_options)
      super options[:game_window_width], options[:game_window_height], false
      update_options

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

    def update_options
      self.shutdown_in = options[:shutdown_in]
      self.shutdown_at_generation = options[:shutdown_at_generation]
      self.scale = options[:scale]
      self.point_size = self.scale
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
      Gol2::GameController.get_active_cells.each do |key, cell|
        draw_quad(cell.x_loc, cell.y_loc, 0xffffffff, cell.x_loc + 2, cell.y_loc, 0xffffffff, cell.x_loc, cell.y_loc + 2, 0xffffffff, cell.x_loc + 2, cell.y_loc + 2, 0xffffffff, 0)
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

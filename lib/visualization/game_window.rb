require 'gosu'

module Gol2
  class GameWindow < Gosu::Window
    attr_accessor :shutdown, :shutdown_in, :shutdown_at_generation, :exit_code, :game_controller,
                  :game_loop, :game_clock, :update_clock, :delta_time, :actual_time, :shutdown_time,
                  :options

    UPDATE_DELAY = 1000

    ZOrderGameUI = 1
    ZOrderGame = 2
    ZOrderGameBackground = 3
    ZOrderWindowUI = 4

    DEFAULTS = {
        window_width: 640,
        window_height: 480,
        game_width: 620,
        game_height: 400
    }

    def initialize(custom_options = {})
      self.options = DEFAULTS.merge(custom_options)
      super options[:window_width], options[:window_height], false
      self.shutdown_in = options[:shutdown_in]
      self.shutdown_at_generation = options[:shutdown_at_generation]
      #@font = Gosu::Font.new(self, Gosu::default_font_name, 18)
      @font = Gosu::Font.new(20)
      # @font = Gosu::Font.new(self, "Arial", 18)
      self.game_loop = 0
      self.caption = "Gosu Tutorial Game"
      self.game_clock = 0
      self.delta_time = 0
      self.update_clock = -1
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
      self.delta_time = Gosu::milliseconds - self.game_clock
      self.game_clock = Gosu::milliseconds()
      check_shutdown
      if !@paused
        if self.game_clock > self.update_clock
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

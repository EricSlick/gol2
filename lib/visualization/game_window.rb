require 'gosu'

module Gol2
  class GameWindow < Gosu::Window
    attr_accessor :shutdown,:shutdown_time, :shutdown_in, :shutdown_at_generation, :exit_code,
                  :game_loop, :game_clock, :update_clock, :delta_time, :last_time,
                  :custom_options, :point_size, :scale, :cell_size, :game_speed, :framerate,
                  :game_width, :game_height, :game_window_width, :game_window_height,
                  :window_width, :window_height, :ui_width, :ui_height, :game_pos_x, :game_pos_y,
                  :ui_icons


    ZOrderGameUI = 3
    ZOrderGame = 2
    ZOrderGameBackground = 1
    ZOrderUI = 4
    DeadCellColor = Gosu::Color.argb(0x66666666)
    LiveCellColor = Gosu::Color.argb(0xffffffff)
    BackgroundColor1 = Gosu::Color.argb(0xff002233)
    BackgroundColor2 = Gosu::Color.argb(0xff001133)
    BackgroundColor3 = Gosu::Color.argb(0xff110033)
    BackgroundColor4 = Gosu::Color.argb(0xff000033)


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
      self.game_speed = 1000
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
      self.ui_width = 200
      self.ui_height = 80
      self.game_pos_x = 0
      self.game_pos_y = self.ui_height
      self.window_width = self.game_window_width + self.ui_width
      self.window_height = self.game_window_height + self.ui_height

      # ui icons
      self.ui_icons ||= {}
      self.ui_icons[:up_arrow] = Gosu::Image.new(self, 'lib/assets/up_arrow.png')
      self.ui_icons[:down_arrow] = Gosu::Image.new(self, 'lib/assets/down_arrow.png')
      self.ui_icons[:title] = Gosu::Image.new(self, 'lib/assets/gol2_title.png')
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
          self.framerate = 1000 / self.delta_time
          self.game_loop += 1
          Gol2::GameController.update_game unless @paused
          self.update_clock += self.game_speed
          controlled_shutdown if self.shutdown_at_generation && self.shutdown_at_generation == self.game_loop
        end
      end
    end

    def draw
      draw_game_background
      draw_cells
      draw_ui
    end

    def draw_cells
      # game_height and width are not the same as game_window_height and width
      # game_height/width is used by the controller to handle the internal size of the game area
      # the game_window_width/height is modified to fit one point size per game_height/width
      # so, when drawing a cell, we have to take into account the visual size (point size) of the cell
      # a point size of 2 means a single game_height/width location of a cell takes up 4 pixels on the game_window

      Gol2::GameController.get_active_cells.each do |key, cell|
        if cell.alive
          LiveCellColor.alpha = cell.increment_birth
          # @debug = "live color: #{LiveCellColor.inspect} #{cell.birth_counter}"
          # LiveCellColor.alpha = cell.birth_counter
          draw_quad(cell.x_loc * self.point_size, cell.y_loc * self.point_size, LiveCellColor,
                    cell.x_loc * self.point_size + self.point_size, cell.y_loc * self.point_size, LiveCellColor,
                    cell.x_loc * self.point_size, cell.y_loc * self.point_size + self.point_size, LiveCellColor,
                    cell.x_loc * self.point_size + self.point_size, cell.y_loc * self.point_size + self.point_size, LiveCellColor,
                    0)
        else
          DeadCellColor.alpha = cell.increment_decay
          draw_quad(cell.x_loc * self.point_size, cell.y_loc * self.point_size, DeadCellColor,
                    cell.x_loc * self.point_size + self.point_size, cell.y_loc * self.point_size, DeadCellColor,
                    cell.x_loc * self.point_size, cell.y_loc * self.point_size + self.point_size, DeadCellColor,
                    cell.x_loc * self.point_size + self.point_size, cell.y_loc * self.point_size + self.point_size, DeadCellColor,
                    0)
        end
      end
    end

    def draw_game_background
      draw_quad(self.game_pos_x, self.game_pos_y, BackgroundColor1,
                self.game_window_width, self.game_pos_y, BackgroundColor2,
                0, self.game_window_height + self.game_pos_y, BackgroundColor3,
                self.game_window_width, self.game_window_height + self.game_pos_y, BackgroundColor4,
                0)

    end

    def draw_ui
      @font.draw("Game Speed", self.game_window_width + 60, 120, ZOrderGameUI, 1.0, 1.0, 0xff_aacc44)
      @font.draw(self.game_speed, self.game_window_width + 60, 160, ZOrderGameUI, 1.0, 1.0, 0xff_aacc44)
      self.ui_icons[:up_arrow].draw(self.game_window_width + 15, 100, ZOrderUI, 0.5, 0.5)
      self.ui_icons[:down_arrow].draw(self.game_window_width + 15, 155, ZOrderUI, 0.5, 0.5)

      # game Title
      self.ui_icons[:title].draw(self.game_window_width/4, 0, ZOrderUI, 0.8, 0.8)

      # other
      @font.draw("Paused", self.game_window_width + 60, 80, ZOrderGameUI, 1.0, 1.0, 0xff_ffff44) if @paused


      #debug info
      debug_x = self.game_window_width + 15
      debug_y = self.game_window_height - 100
      @font.draw("GameLoop: #{self.game_loop}",
                 debug_x, debug_y, ZOrderGameUI, 1.0, 1.0, 0xff_ffff00)
      @font.draw("ActiveCells: #{Gol2::GameController.get_active_cells.length}",
                 debug_x, debug_y + 30, ZOrderGameUI, 1.0, 1.0, 0xff_ffff00)
      @font.draw("Framerate: #{self.framerate}",
                 debug_x, debug_y + 60, ZOrderGameUI, 1.0, 1.0, 0xff_ffff00)
      @font.draw(@debug, 10, 35, ZOrderGameUI, 1.0, 1.0, 0xff_ffff00) if @debug

    end

    def needs_cursor?
      true
    end

    def button_down(key_id)
      case key_id
        when Gosu::KbSpace
          @paused = @paused != true
        when Gosu::KbUp
          self.game_speed -= 100 unless self.game_speed < 200
        when Gosu::KbDown
          self.game_speed += 100
      end
    end
  end
end

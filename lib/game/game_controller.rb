
module Gol2
  class GameController
    SEED_TYPE = {
        random: :random
    }

    # define shapes for a viable cell grouping
    # center cell is implied
    VIABLE_SHAPES = {
        #
        column: [:n, :s], #
        #
        row: [:w, :e], ###
        #
        backslash: [:nw, :se], #
        #
        #
        forwardslash: [:ne, :sw], #
        #
        ##
        ul_corner: [:e, :s], #

        ##
        ur_corner: [:w, :s],   #

        #
        lr_corner: [:n, :w], ##

        #
        ll_corner: [:n, :e] ##
    }

    # when given a compass point, return the offset from the current cell's location
    X_OFFSET = {
        n: 0,
        s: 0,
        nw: -1,
        sw: -1,
        w: -1,
        ne: 1,
        e: 1,
        se: 1,
    }

    Y_OFFSET = {
        n: 1,
        nw: 1,
        ne: 1,
        w: 0,
        e: 0,
        s: -1,
        sw: -1,
        se: -1
    }

    DEFAULT_OPTIONS = {
        game_width: 640,
        game_height: 400,
        window_width: 640,
        window_height: 400
    }

    class << self
      attr_accessor :testing
      attr_accessor :game_window, :active_cells, :reserve_cells, :game_options, :custom_options
      attr_accessor :game_width, :game_height, :window_width, :window_height

      def run(options = {})
        self.custom_options = options
        self.reset
        unless Gol2::GameController.testing
          game_window = Gol2::GameWindow.new
          game_window.game_controller = self
          game_window.show
        end
      end

      def reset
        self.custom_options ||=  {}
        self.game_options = DEFAULT_OPTIONS.merge(self.custom_options)
        self.game_width = self.game_options[:game_width]
        self.game_height = self.game_options[:game_height]
        self.reserve_cells = []
        self.active_cells = {}
        self.active_cells.clear
        self.reserve_cells.clear
      end

      def seed_universe(seeds = 1, seed_type = SEED_TYPE[:random])
        raise "can't seed a universe that already has active cells" if self.active_cells.length > 0
        1.upto(seeds).each do |index|
          seed_viable_cell_group(seed_type)
        end
      end

      #
      # fetch_a_cell_for
      #
      # responsible for returning a valid cell to the requesting cell
      #   it tries to get one from the active list (has an x/y coordinate on game window)
      #   then it tries to pull it off the reserve list
      #   finally it will just create a new one
      # this is the only place cells should be created so they can be managed centrally
      def fetch_a_cell_for(cell, compass_point)
        #get a cell from the reserve or create one
        fetch_x = cell.x_loc + X_OFFSET[compass_point]
        fetch_y = cell.y_loc + Y_OFFSET[compass_point]
        self.active_cells[fetch_x] ||= {}
        fetched_cell = self.active_cells[fetch_x][fetch_y]
        if !fetched_cell
          fetched_cell = self.reserve_cells.pop || Gol2::Cell.new
          fetched_cell.x_loc = fetch_x
          fetched_cell.y_loc = fetch_y
          self.active_cells[fetch_x][fetch_y] = fetched_cell
        end
        fetched_cell
      end

      # get a new cell at the x/y coordinates
      # x/y must already refer to an empty location
      def create_a_cell_at(new_x, new_y)
        self.active_cells[new_x] ||= {}
        cell = self.active_cells[new_x][new_y]
        raise "cannot create a cell at #{new_x}, #{new_y} as it's already occupied by one" if cell
        cell = self.reserve_cells.pop || Gol2::Cell.new
        cell.x_loc = new_x
        cell.y_loc = new_y
        self.active_cells[new_x][new_y] = cell
        cell
      end

      private

      # a cell group that can replicate
      def seed_viable_cell_group(seed_type = SEED_TYPE[:random])
        raise "seed_type must not be nil" if !seed_type
        seed_shape =
            case seed_type
              when SEED_TYPE[:random]
                random_key = VIABLE_SHAPES.keys[Random.rand(VIABLE_SHAPES.length)]
                VIABLE_SHAPES[random_key]

            end
        location = get_empty_location(:center)
        seed_cell = create_a_cell_at(location[:x], location[:y])
        seed_cell.awaken
        seed_shape.each do |compass_point|
          neighbor = seed_cell.get_neighbor(compass_point)
          neighbor.awaken
        end
        return seed_cell
      end

      # gets an x/y location without any cells in it
      # returns nil if it can't find one in 20 attempts
      # this should be used to begin a new gol
      # todo: optimize this if it's to be used later in the game
      def get_empty_location(area = nil)
        case area
          when :center
            index = 0
            loop do
              x = Random.rand(game_width / 2) + game_width / 4
              y = Random.rand(game_height / 2) + game_height / 4
              self.active_cells[x] ||= {}
              return {x: x, y: y} if !self.active_cells[x][y]
              index += 1
              break if index > 20
            end
          else

        end
        return nil
      end

    end
  end
end
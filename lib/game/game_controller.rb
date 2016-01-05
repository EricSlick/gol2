
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

    class << self
      attr_accessor :testing
      attr_accessor :game_window, :active_cells, :reserve_cells

      def run
        unless Gol2::GameController.testing
          game_window = Gol2::GameWindow.new
          game_window.game_controller = self
          game_window.show
        end
      end

      def reset
        self.active_cells = []
        self.reserve_cells = []
      end


      def seed_universe(seeds = 1, seed_type = SEED_TYPE[:random])
        0.upto(seeds).each do |index|
          create_viable_cell_group(seed_type)
        end
      end

      # a cell group that can replicate
      def create_viable_cell_group(seed_type = SEED_TYPE[:random])
        raise "seed_type must not be nil" if !seed_type
        seed_shape =
            case seed_type
              when SEED_TYPE[:random]
                random_key = VIABLE_SHAPES.keys[Random.rand(VIABLE_SHAPES.length)]
                VIABLE_SHAPES[random_key]

            end
        seed_cell = fetch_new_cell(:alive)
        seed_shape.each do |compass_point|
          seed_cell.add_neighbor(compass_point, fetch_new_cell(:alive))
        end
      end

      def fetch_new_cell(dead_or_alive = false)
        #get a cell from the reserve or create one
        self.active_cells ||= []
        self.reserve_cells ||= []
        new_cell = self.reserve_cells.pop || Gol2::Cell.new(dead_or_alive)
        self.active_cells.push(new_cell)
        new_cell
      end
    end
  end
end
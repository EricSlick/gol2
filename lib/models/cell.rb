module Gol2
  class Cell
    attr_accessor :x_loc, :y_loc
    attr_accessor :all_neighbors, :live_neighbors
    attr_accessor :generation, :alive

    COMPASS_POINTS = {
        n: :s,
        ne: :sw,
        e: :w,
        se: :nw,
        s: :n,
        sw: :ne,
        w: :e,
        nw: :se
    }

    def initialize(alive = false)
      self.alive = alive
      self.all_neighbors = {}
      self.live_neighbors = {}
      reset
    end

    def generate
      if self.alive?
        next_generation
      else
        check_fertility
      end

    end

    def alive?
      self.alive
    end

    def next_generation
      self.generation += 1
      case self.live_neighbors.length
        when 2, 3
        else
          self.alive = false
      end
    end

    def check_fertility
      case self.live_neighbors.length
        when 3
          give_birth
      end
    end

    def give_birth
      self.alive = true
      COMPASS_POINTS.each do |point, opposite_point|
        self.add_neighbor(point)
      end
    end

    def link_back(compass_point, cell)
      add_neighbor(COMPASS_POINTS[compass_point], cell)
    end

    def add_neighbor(compass_point, cell = Gol2::Cell.new)
      if !all_neighbors[compass_point]
        all_neighbors[compass_point] = cell
        live_neighbors[compass_point] = cell if cell.alive?
        cell.link_back(compass_point, self) if self.alive?
      else
        # raise "Can't add neighbor when one is already set."
      end
    end

    def back_link_cell(compass_point)
      self.all_neighbors[COMPASS_POINTS[compass_point]]
    end

    def reset
      self.x_loc = 0
      self.y_loc = 0
      self.generation = 1
      give_birth if self.alive?
    end
  end
end
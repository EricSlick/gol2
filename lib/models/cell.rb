module Gol2
  class Cell
    attr_accessor :x_loc, :y_loc
    attr_accessor :all_neighbors, :live_neighbors
    attr_accessor :generation, :alive

    OPPOSITE_POINTS = {
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
      self.generation += 1
      next_generation
    end

    def alive?
      self.alive
    end

    def next_generation
      if self.live_neighbors.length < 2 || self.live_neighbors.length > 3
        self.alive = false
      end
    end

    def link_back(compass_point, cell)
      add_neighbor(OPPOSITE_POINTS[compass_point], cell)
    end

    def add_neighbor(compass_point, cell)
      if !all_neighbors[compass_point]
        all_neighbors[compass_point] = cell
        live_neighbors[compass_point] = cell if cell.alive?
        cell.link_back(compass_point, self) if self.alive?
      else
        raise "Can't add neighbor when one is already set."
      end
    end

    def back_link_cell(compass_point)
      self.all_neighbors[OPPOSITE_POINTS[compass_point]]
    end

    def reset
      self.x_loc = 0
      self.y_loc = 0
      self.generation = 1
      self.add_neighbor(:n, Gol2::Cell.new) if self.alive?
      self.add_neighbor(:ne, Gol2::Cell.new) if self.alive?
      self.add_neighbor(:e, Gol2::Cell.new) if self.alive?
      self.add_neighbor(:se, Gol2::Cell.new) if self.alive?
      self.add_neighbor(:s, Gol2::Cell.new) if self.alive?
      self.add_neighbor(:sw, Gol2::Cell.new) if self.alive?
      self.add_neighbor(:w, Gol2::Cell.new) if self.alive?
      self.add_neighbor(:nw, Gol2::Cell.new) if self.alive?
    end
  end
end
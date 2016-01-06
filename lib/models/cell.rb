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
      self.alive = (alive == true || alive == :true || alive == :alive)
      self.all_neighbors = {}
      self.live_neighbors = {}
      self.x_loc = 0
      self.y_loc = 0
      self.generation = 1
      awaken if self.alive?
    end

    def alive?
      self.alive
    end

    def dead?
      !self.alive
    end

    #
    # GOL Rules for Cell
    #

    def generate
      if self.alive?
        next_generation
      else
        check_fertility
      end
    end

    def next_generation
      self.generation += 1
      case self.live_neighbors.length
        when 2, 3
        else
          self.alive = false
      end
    end

    #
    # cell actions
    #

    # make a cell alive and ensure it has neighbors for all compass points
    def awaken
      self.alive = true
      COMPASS_POINTS.each do |point, opposite_point|
        self.add_neighbor(point)
      end
    end

    def check_fertility
      case self.live_neighbors.length
        when 3
          awaken
      end
    end


    #
    # neighbor and link management
    #

    # ensure we have a cell at this compass point
    def add_neighbor(compass_point)
      # check if we already have a cell at that compass_point
      if all_neighbors[compass_point]
        # todo: don't expect there's anything to do here, even whether it's alive or dead since that should be handled/managed at birth/death
        # might need to check if this
      else
        cell = Gol2::GameController.fetch_a_cell_for(self, compass_point)
        # cell.add_backlinked_neighbor(cell, compass_point) #new cells should link back to the live cell
        all_neighbors[compass_point] = cell
        live_neighbors[compass_point] = cell if cell.alive?
        cell.neighbor_changed_at(COMPASS_POINTS[compass_point], self)
      end
    end

    #inform a cell that a change has occurred with a cell at one of its compass points
    def neighbor_changed_at(compass_point, changed_cell)
      cell = self.all_neighbors[compass_point]
      if cell
        self.live_neighbors = {}
        self.all_neighbors.each do |cp, neighbor|
          # todo: this is brute force for now...this should be one operation instead of a loop
          self.live_neighbors[compass_point] if neighbor.alive?
        end
      else
        cell = Gol2::GameController.fetch_a_cell_for(self, compass_point)
        if cell.object_id != changed_cell.object_id
          stophere = 0
        end
        self.all_neighbors[compass_point] = cell
        self.live_neighbors[compass_point] = cell if cell.alive?
      end
    end

    # # helper for add_neighbor to ensure a newly created dead cell has added the live cell as the appropriate compass point
    # def add_backlinked_neighbor(cell, compass_point)
    #   # get the cell for the connecting compass point (ie, if compass point is :n, then we need :s to find the back link)
    #   cell = Gol2::GameController.fetch_a_cell_for(cell, COMPASS_POINTS[compass_point])
    #   cell should equal self
    #   cell.add_neighbor(self)
    #   # this cell could be alive or dead.
    #   # IF it's alive, it already has all its compass points set
    #   #   in this case, if the
    #   # if it's dead, it may or may not have the compass point set
    #
    #   # opposite_point = COMPASS_POINTS[compass_point]
    #   # self.add_neighbor(opposite_point)
    # end

    # return neighbor at compass_point
    def get_neighbor(compass_point)
      self.all_neighbors[COMPASS_POINTS[compass_point]]
    end

  end
end
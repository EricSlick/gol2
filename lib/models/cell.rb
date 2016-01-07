module Gol2
  class Cell
    attr_accessor :x_loc, :y_loc, :key, :neighbor_keys,
                  :cell_age, :alive, :alive_next, :decay_counter, :birth_counter


    # xy is from upper left corner
    COMPASS_POINTS = {
        n: [0, -1],
        ne: [1, -1],
        e: [1, 0],
        se: [1, 1],
        s: [0, 1],
        sw: [-1, 1],
        w: [-1, 0],
        nw: [-1, -1]
    }

    def initialize(alive = false)
      self.alive = (alive == true || alive == :true || alive == :alive)
      self.alive_next = self.alive
      self.x_loc = 0
      self.y_loc = 0
      self.cell_age = 1
      self.decay_counter = 255
      self.birth_counter = 100
      regenerate_neighbor_keys
    end

    def increment_decay
      self.decay_counter -= 5 unless self.decay_counter == 100
      self.decay_counter
    end

    def increment_birth
      self.birth_counter += 5 unless self.birth_counter == 255
      self.birth_counter
    end

    def x_loc=(value)
      @x_loc = value
      regenerate_neighbor_keys if self.y_loc
    end

    def y_loc=(value)
      @y_loc = value
      regenerate_neighbor_keys if self.x_loc
    end

    def live_life
      @lived_life = true
      if self.alive
        do_some_living
      else
        check_fertility
      end
    end

    def changed_life_state
      raise "Can't age cell until it's lived its life (#live_life) first" if !@lived_life
      changed = self.alive != self.alive_next
      self.alive = self.alive_next
      @life_lived = false
      changed
    end

    #
    # GOL Rules for Cell
    #

    def do_some_living
      self.cell_age += 1
      case self.live_neighbors.length
        when 2, 3
        else
          self.alive_next = false
          self.birth_counter = 100
      end
    end

    def check_fertility
      case self.live_neighbors.length
        when 3
          self.alive_next = true
          self.decay_counter = 255
      end
    end

    #
    # a cell's neighborhood
    #
    def live_neighbors
      neighbors = {}
      self.neighbor_keys.values.each do |key|
        cell = Gol2::GameController.active_cells[key]
        if cell
          neighbors[key] = cell if cell.alive
        end
      end
      neighbors
    end

    def all_neighbors
      neighbors = {}
      self.neighbor_keys.values.each do |key|
        cell = Gol2::GameController.active_cells[key]
        neighbors[key] = cell
      end
      neighbors
    end

    def get_neighbor_key(compass_point)
      self.neighbor_keys[compass_point]
    end

    def regenerate_neighbor_keys
      return nil unless self.x_loc && self.y_loc
      COMPASS_POINTS.each do |cp, xy|
        self.neighbor_keys ||= {}
        self.neighbor_keys[cp] = (self.x_loc + xy[0]) * KEY_OFFSET + (self.y_loc + xy[1])
      end
      self.key = (self.x_loc) * KEY_OFFSET + (self.y_loc)
    end

  end
end

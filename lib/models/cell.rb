module Gol2
  class Cell
    attr_accessor :x_loc, :y_loc
    attr_accessor :neighbors, :n_neighbor, :ne_neighbor, :e_neighbor, :se_neighbor, :s_neighbor, :sw_neighbor, :w_neighbor, :nw_neighbor
    attr_accessor :generation, :alive

    def initialize
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
      if self.neighbors < 2 || self.neighbors > 3
        self.alive = false
      end
    end

    def add_neighbor(compass_point, cell)
      position = "#{compass_point}_neighbor".to_sym
      # current_cell = self.send(position)
      self.send("#{position}=", cell)
      self.neighbors += 1
    end

    def reset
      self.x_loc = 0
      self.y_loc = 0
      self.generation = 1
      self.alive = true
      self.neighbors = 0
      self.n_neighbor = nil
      self.ne_neighbor = nil
      self.e_neighbor = nil
      self.se_neighbor = nil
      self.s_neighbor = nil
      self.nw_neighbor = nil
      self.w_neighbor = nil
    end

  end
end
module Gol2
  class Cell
    attr_accessor :x_loc, :y_loc, :n_neighbor, :ne_neighbor, :e_neighbor, :se_neighbor, :s_neighbor, :sw_neighbor, :w_neighbor, :nw_neighbor
    attr_accessor :generation

    def initialize
      @x_loc = 0
      @y_loc = 0
      @generation = 1
    end

    def generate
      @generation += 1
    end

    def alive?
      return false
    end

  end
end
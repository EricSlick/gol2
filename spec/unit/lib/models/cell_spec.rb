require 'spec_helper'

describe Gol2::Cell do

  let(:cell) { Gol2::Cell.new }
  let(:n_neighbor) { Gol2::Cell.new }
  let(:ne_neighbor) { Gol2::Cell.new }
  let(:e_neighbor) { Gol2::Cell.new }
  let(:se_neighbor) { Gol2::Cell.new }
  let(:s_neighbor) { Gol2::Cell.new }
  let(:sw_neighbor) { Gol2::Cell.new }
  let(:w_neighbor) { Gol2::Cell.new }
  let(:nw_neighbor) { Gol2::Cell.new }
  let(:neighbors) {
    {
        n: n_neighbor,
        ne: n_neighbor,
        e: n_neighbor,
        se: n_neighbor,
        s: n_neighbor,
        sw: n_neighbor,
        w: n_neighbor,
        nw: n_neighbor,
    }

  }

  context "x/y" do
    it "has an x/y coordinate" do
      expect(cell.x_loc).to eq 0
      expect(cell.y_loc).to eq 0
    end

    it "can change its x/y position" do
      cell.x_loc = 50
      cell.y_loc = 25
      expect(cell.x_loc).to eq 50
      expect(cell.y_loc).to eq 25
    end
  end

  context 'neighbors' do
    before :each do
      cell.n_neighbor = n_neighbor
      cell.ne_neighbor = ne_neighbor
      cell.e_neighbor = e_neighbor
      cell.se_neighbor = se_neighbor
      cell.s_neighbor = s_neighbor
      cell.sw_neighbor = sw_neighbor
      cell.w_neighbor = w_neighbor
      cell.nw_neighbor = nw_neighbor
    end

    it "has neighbors" do
      expect(cell.n_neighbor).to be n_neighbor
      expect(cell.ne_neighbor).to be ne_neighbor
      expect(cell.e_neighbor).to be e_neighbor
      expect(cell.se_neighbor).to be se_neighbor
      expect(cell.s_neighbor).to be s_neighbor
      expect(cell.sw_neighbor).to be sw_neighbor
      expect(cell.w_neighbor).to be w_neighbor
      expect(cell.nw_neighbor).to be nw_neighbor
    end
  end

  context 'cell generations' do
    it 'can generate a new generation' do
      expect { cell.generate }.to change { cell.generation }.by(1)
    end

    it 'starts out alive' do
      expect(cell.alive?).to eq true
    end
  end

  context 'implements basic game of life rules' do
    context "Cell dies from under-population" do
      it 'when no other cells next to it' do
        cell.generate
        expect(cell.alive?).to eq false
      end

      it 'dies if only one adjacent live cell' do
        neighbors.each do |key, neighbor|
          cell.reset
          cell.add_neighbor(key, neighbor)
          cell.generate
          expect(cell.alive?).to eq false
        end
      end

    end
    
    context "Cell lives on to the next generation with adequate population." do
      it 'when cell has two or three neighbors' do
        index = 1
        neighbors.each do |key, neighbor|
          cell.alive = true
          cell.add_neighbor(key, neighbor)
          cell.generate
          expect(cell.alive?).to eq true if index > 1
          index += 1
          exit if index == 3
        end
      end

    end
    
    context "Cell dies from over-population" do
      it "when it has four or more live neighbours" do
        index = 1
        neighbors.each do |key, neighbor|
          cell.alive = true
          cell.add_neighbor(key, neighbor)
          cell.generate if index > 3
          expect(cell.alive?).to eq false if index > 3
        end
      end
    end

    context "Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do

    end

  end
end
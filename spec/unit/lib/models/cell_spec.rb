require 'spec_helper'

describe Gol2::Cell do

  let(:alive) { true }
  let(:cell) { Gol2::Cell.new(alive) }
  let(:dead_cell) { Gol2::Cell.new }

  context 'given a basic cell class' do
    context 'then a class instance' do
      it "#x/#y can change its x/y position" do
        cell.x_loc = 50
        cell.y_loc = 25
        expect(cell.x_loc).to eq 50
        expect(cell.y_loc).to eq 25
      end

      it '#generate can advance to a new generation' do
        expect { cell.generate }.to change { cell.generation }.by(1)
      end

      it "OPPOSITE_POINTS constant can return the correct opposite compass point" do
        {
            n: :s,
            ne: :sw,
            e: :w,
            se: :nw,
            s: :n,
            sw: :ne,
            w: :e,
            nw: :se,
        }.each do |k, v|
          expect(Gol2::Cell::OPPOSITE_POINTS[k]).to eq v
        end
      end
    end

    context "when instantiated" do
      it "has neighbors" do
        expect(cell.all_neighbors.length).to eq 8
      end

      it "has an x/y coordinate" do
        expect(cell.x_loc).to eq 0
        expect(cell.y_loc).to eq 0
      end

      context 'and the cell is instantiated as alive' do
        it 'then it starts actually alive' do
          expect(cell.alive?).to eq true
        end

        it 'then all neighbors are defined' do
          expect(cell.all_neighbors.length).to eq 8
        end

        it 'then all neighbors are linked back to it' do
          cell.all_neighbors.each do |compass_point, linked_cell|
            expect(linked_cell.back_link_cell(compass_point).object_id).to eq cell.object_id
          end
        end
      end

      context 'and the cell is instantiated as dead' do
        it 'then it is actually dead' do
          expect(dead_cell.alive?).to eq false
        end

        it 'then it has no back-linked cells' do
          expect(dead_cell.all_neighbors.length).to eq 0
        end

        #todo: can't have a dead cell with no live cells attached to it without it being in the dead pool
        # it 'then it will be in the unassigned pool of cells' do
        #   pending "when the game manager is created and this should move to that spec"
        #   expect(true).to eq false
        # end
      end

    end
  end

  context 'given the basic game of life rules' do
    context "when a cell has no living neighbors" do
      it 'it dies' do
        cell.generate
        expect(cell.alive?).to eq false
      end
    end


    context "when a cell has only one living neighbor" do
      it 'it dies' do
        cell.all_neighbors[:n].alive = true
        cell.live_neighbors[:n] = cell.all_neighbors[:n]
        cell.generate
        expect(cell.alive?).to eq false
      end

    end

    context "when a cell has only two live neighbors" do
      it 'it lives another generation' do
        cell.all_neighbors[:ne].alive = true
        cell.all_neighbors[:e].alive = true
        cell.live_neighbors[:ne] = cell.all_neighbors[:ne]
        cell.live_neighbors[:e] = cell.all_neighbors[:e]
        cell.generate
        expect(cell.alive?).to eq true
      end
    end

    context "when a cell has only three live neighbors" do
      it 'it lives another generation' do
        cell.all_neighbors[:ne].alive = true
        cell.all_neighbors[:e].alive = true
        cell.all_neighbors[:se].alive = true
        cell.live_neighbors[:ne] = cell.all_neighbors[:ne]
        cell.live_neighbors[:e] = cell.all_neighbors[:e]
        cell.live_neighbors[:se] = cell.all_neighbors[:se]
        cell.generate
        expect(cell.alive?).to eq true
      end
    end

    context "Cell dies from over-population" do
      it "when it has four or more live neighbours" do
        cell.all_neighbors[:ne].alive = true
        cell.all_neighbors[:e].alive = true
        cell.all_neighbors[:se].alive = true
        cell.all_neighbors[:s].alive = true
        cell.live_neighbors[:ne] = cell.all_neighbors[:ne]
        cell.live_neighbors[:e] = cell.all_neighbors[:e]
        cell.live_neighbors[:se] = cell.all_neighbors[:se]
        cell.live_neighbors[:s] = cell.all_neighbors[:s]
        cell.generate
        expect(cell.alive?).to eq false
      end
    end

    context "Birthing a cell" do
      # triangle row corner disconnected
      #   *  ***  *      *
      #  *#*  #  #*  #*   #
      #           *  **   * *
      #
      it 'when an empty location has exactly three live cell neighbors' do
        #stop to consider how to handle empty cells
      end
    end

  end
end

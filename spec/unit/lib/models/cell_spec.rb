require 'spec_helper'

describe "Given a #{Gol2::Cell.name} class" do

  let(:alive) { true }
  let(:cell) { Gol2::Cell.new(alive) }
  let(:dead_cell) { Gol2::Cell.new }

  context "when instantiated" do
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
        expect(Gol2::Cell::COMPASS_POINTS[k]).to eq v
      end
    end

    it "is created dead by default" do
      expect(Gol2::Cell.new.alive?).to be false
    end

    context "with a boolean" do
      it "is instantiated alive" do
        expect(Gol2::Cell.new(true).alive?).to be true
      end

      it "is instantiated dead" do
        expect(Gol2::Cell.new(false).alive?).to be false
      end
    end

    context "with a symbol" do
      it "is instantiated alive using :true" do
        expect(Gol2::Cell.new(:true).alive?).to be true
      end

      it "is instantiated alive using :alive" do
        expect(Gol2::Cell.new(:alive).alive?).to be true
      end

      it "is instantiated dead using :false" do
        expect(Gol2::Cell.new(:false).alive?).to be false
      end

      it "is instantiated dead using :dead" do
        expect(Gol2::Cell.new(:dead).alive?).to be false
      end
    end

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
          expect(linked_cell.get_neighbor(compass_point).object_id).to eq cell.object_id
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

  context 'that implements the basic game of life rules' do
    context "when a cell has no living neighbors" do
      it 'then it dies' do
        cell.generate
        expect(cell.alive?).to eq false
      end
    end

    context "when a cell has only one living neighbor" do
      it 'then it dies' do
        cell.all_neighbors[:n].alive = true
        cell.live_neighbors[:n] = cell.all_neighbors[:n]
        cell.generate
        expect(cell.alive?).to eq false
      end
    end

    context "when a cell has only two live neighbors" do
      it 'then it lives another generation' do
        cell.all_neighbors[:ne].alive = true
        cell.all_neighbors[:e].alive = true
        cell.live_neighbors[:ne] = cell.all_neighbors[:ne]
        cell.live_neighbors[:e] = cell.all_neighbors[:e]
        cell.generate
        expect(cell.alive?).to eq true
      end
    end

    context "when a cell has only three live neighbors" do
      it 'then it lives another generation' do
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

    context "when a cell had four or more live neighbors" do
      it "then it dies due to over-population" do
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

    context "when a dead cell has exactly three neighbors" do
      # triangle row corner disconnected
      #   *  ***  *      *
      #  *#*  #  #*  #*   #
      #           *  **   * *
      #
      it 'then it becomes a living cell as if by birth' do
        expect(dead_cell.alive?).to eq false
        dead_cell.add_neighbor(:ne)
        new_live_cell = Gol2::Cell.new(true)
        dead_cell.add_neighbor(:e)
        new_live_cell = Gol2::Cell.new(true)
        dead_cell.add_neighbor(:se)
        dead_cell.generate
        expect(dead_cell.alive?).to eq true
      end
    end

  end
end

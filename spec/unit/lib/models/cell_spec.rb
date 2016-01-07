require 'spec_helper'

describe "Given a #{Gol2::Cell.name} class" do

  let(:cell) { Gol2::Cell.new(:alive) }
  let(:dead_cell) { Gol2::Cell.new }

  context "when instantiated" do
    before :each do
      allow(cell).to receive(:live_neighbors).and_return({1 => nil})
    end

    it "#x/#y can change its x/y position" do
      cell.x_loc = 50
      cell.y_loc = 25
      expect(cell.x_loc).to eq 50
      expect(cell.y_loc).to eq 25
    end

    it '#generate can advance to a new generation' do
      expect { cell.live_life }.to change { cell.cell_age }.by(1)
    end

    it "COMPASS_POINTS return x/y offsets from cell position" do
      {
          n: [0, -1],
          ne: [1, -1],
          e: [1, 0],
          se: [1, 1],
          s: [0, 1],
          sw: [-1, 1],
          w: [-1, 0],
          nw: [-1, -1]
      }.each do |k, v|
        expect(Gol2::Cell::COMPASS_POINTS[k]).to eq v
      end
    end

    it "#get_neighbor_xy returns xy coords of specified position" do
      expected_key = (cell.x_loc) * (Gol2::KEY_OFFSET) + (cell.y_loc) -1
      expect(cell.get_neighbor_key(:n)).to eq(expected_key)
    end

    it "is created dead by default" do
      expect(Gol2::Cell.new.alive).to be false
    end

    context "with a boolean" do
      it "is instantiated alive" do
        expect(Gol2::Cell.new(true).alive).to be true
      end

      it "is instantiated dead" do
        expect(Gol2::Cell.new(false).alive).to be false
      end
    end

    context "with a symbol" do
      it "is instantiated alive using :true" do
        expect(Gol2::Cell.new(:true).alive).to be true
      end

      it "is instantiated alive using :alive" do
        expect(Gol2::Cell.new(:alive).alive).to be true
      end

      it "is instantiated dead using :false" do
        expect(Gol2::Cell.new(:false).alive).to be false
      end

      it "is instantiated dead using :dead" do
        expect(Gol2::Cell.new(:dead).alive).to be false
      end
    end

    it "has an x/y coordinate" do
      expect(cell.x_loc).to eq 0
      expect(cell.y_loc).to eq 0
    end

    context 'and the cell is instantiated as alive' do
      it 'then it starts actually alive' do
        expect(cell.alive).to eq true
      end
    end

    context 'and the cell is instantiated as dead' do
      it 'then it is actually dead' do
        expect(dead_cell.alive).to eq false
      end
    end

  end

  context 'that implements the basic game of life rules' do
    context "when a cell has no living neighbors" do
      it 'then it dies' do
        allow(cell).to receive(:live_neighbors).and_return({})
        cell.live_life
        cell.changed_life_state
        expect(cell.alive).to eq false
      end
    end

    context "when a cell has only one living neighbor" do
      it 'then it dies' do
        allow(cell).to receive(:live_neighbors).and_return({1 => nil})
        cell.live_life
        cell.changed_life_state
        expect(cell.alive).to eq false
      end
    end

    context "when a cell has only two live neighbors" do
      it 'then it lives another generation' do
        allow(cell).to receive(:live_neighbors).and_return({1 => nil, 2 => nil})
        cell.live_life
        cell.changed_life_state
        expect(cell.alive).to eq true
      end
    end

    context "when a cell has only three live neighbors" do
      it 'then it lives another generation' do
        allow(cell).to receive(:live_neighbors).and_return({1 => nil, 2 => nil, 3 => nil})
        cell.live_life
        cell.changed_life_state
        expect(cell.alive).to eq true
      end
    end

    context "when a cell had four or more live neighbors" do
      it "then it dies due to over-population" do
        allow(cell).to receive(:live_neighbors).and_return({1 => nil, 2 => nil, 3 => nil, 4 => nil})
        cell.live_life
        cell.changed_life_state
        expect(cell.alive).to eq false
      end
    end

    context "when a dead cell has exactly three neighbors" do
      it 'then it becomes a living cell as if by birth' do
        expect(dead_cell.alive).to eq false
        allow(dead_cell).to receive(:live_neighbors).and_return({1 => nil, 2 => nil, 3 => nil})
        dead_cell.live_life
        expect(dead_cell.alive_next).to eq true
        expect(dead_cell.alive).to eq false
        dead_cell.changed_life_state
        expect(dead_cell.alive).to eq true
      end
    end

    context "to support birth and decay" do
      it 'has a decay counter' do
        expect{cell.increment_decay}.to change{cell.decay_counter}
      end
      it 'has a birth counter' do
        expect{cell.increment_birth}.to change{cell.birth_counter}
      end
    end

  end
end

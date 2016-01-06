require 'spec_helper'

describe "Given a #{Gol2::GameController.name}" do
  let(:gol2_controller){ Gol2::GameController}

  before :each do
    gol2_controller.reset
  end

  it 'has a game board' do
    expect(gol2_controller.game_width).to be > 100
    expect(gol2_controller.game_height).to be > 100
  end


  context "when asking for a location" do
    context "and location is specified as :center" do
      it 'then returns a location inside the center area' do
        location = gol2_controller.send(:get_empty_location, :center)
        expect(location).to_not be_nil
      end
    end
  end

  context 'when obtaining a cell' do
    context 'and creating one at a specific location' do
      it '#create_a_cell_at returns a cell' do
        cell = gol2_controller.send(:create_a_cell_at, 200, 201)
        expect(cell).to_not be nil
      end
    end

    context 'and fetching a cell' do
      context '#fetch_a_cell_for another cell' do
        it 'returns a cell' do
          cell = gol2_controller.send(:create_a_cell_at, 200, 201)
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :n)
          expect(fetched_cell).to_not be_nil
        end

        it 'returns a cell at a valid x/y coordinate' do
          cell = gol2_controller.send(:create_a_cell_at, 200, 201)
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :n)
          expect(fetched_cell.x_loc).to eq 200
          expect(fetched_cell.y_loc).to eq 202
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :s)
          expect(fetched_cell.x_loc).to eq 200
          expect(fetched_cell.y_loc).to eq 200
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :e)
          expect(fetched_cell.x_loc).to eq 201
          expect(fetched_cell.y_loc).to eq 201
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :w)
          expect(fetched_cell.x_loc).to eq 199
          expect(fetched_cell.y_loc).to eq 201
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :nw)
          expect(fetched_cell.x_loc).to eq 199
          expect(fetched_cell.y_loc).to eq 202
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :w)
          expect(fetched_cell.x_loc).to eq 199
          expect(fetched_cell.y_loc).to eq 201

        end
      end
    end
  end

  context 'when seeding' do
    it '#seed_viable_cell_group creates a group of cells that can give birth to new cells' do
      seed_cell = gol2_controller.send(:seed_viable_cell_group)
      expect(seed_cell).to_not be_nil
      expect(seed_cell.live_neighbors.length).to eq 2
    end

    it '#seed_universe creates the correct number of cells' do
      gol2_controller.seed_universe(1, Gol2::GameController::SEED_TYPE[:random])
      expect([19, 15, 14]).to include(gol2_controller.active_cells.length)
      expect(gol2_controller.reserve_cells.length).to eq 0
    end
  end

  it 'can return a cell at a specific location' do

  end

  #
  # notes
  #

  # number of cells created by a shape
  #   19    15    14
  #    ***  ***   ***
  #   *o#*  o#o   o#o
  #  *o#o*  o#o   o##*
  #  *#o*   o#o   *oo*
  #  ***    ***



end
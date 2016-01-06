require 'spec_helper'

describe "Given a #{Gol2::GameController.name} class" do
  let(:gol2_controller){ Gol2::GameController}

  before :each do
    gol2_controller.reset
  end

  it 'has a game board' do
    expect(gol2_controller.game_width).to be > 100
    expect(gol2_controller.game_height).to be > 100
  end

  it 'can run the game' do
    gol2_controller.skip_visualization = true
    expect(gol2_controller.run).to eq true
  end

  it 'can reset the game options' do
    gol2_controller.run({one: "two", three: 'four'})
    gol2_controller.active_cells = {1 => 'one', 2 => 'two'}
    gol2_controller.reserve_cells = [1, 2, 3]
    gol2_controller.game_width = 123
    gol2_controller.reset
    expect(gol2_controller.active_cells).to eq({})
    expect(gol2_controller.reserve_cells).to eq([])
    expect(gol2_controller.custom_options[:one]).to eq "two"
    expect(gol2_controller.game_width).to eq(Gol2::GameController::DEFAULT_OPTIONS[:game_width])
  end

  it 'can return active_cells' do
    expect(gol2_controller.active_cells).to eq({})
    gol2_controller.active_cells = {1 => 'one', 2 => 'two'}
    expect(gol2_controller.active_cells).to eq({1 => 'one', 2 => 'two'})
  end

  context "when seeding the game board" do
    context "and location is specified as :center" do
      it 'then returns a location inside the center area' do
        location = gol2_controller.send(:get_empty_location, :center)
        expect(location).to_not be_nil
      end
    end
  end

  context 'when obtaining a cell' do
    context 'by creating one at a specific location' do
      it '#create_a_cell_at returns a cell' do
        cell = gol2_controller.send(:create_seed_cell_at, 200, 201)
        expect(cell).to_not be nil
      end
    end

    context 'by fetching a cell' do
      context '#fetch_a_cell_for another cell' do
        it 'returns a cell' do
          cell = gol2_controller.send(:create_seed_cell_at, 200, 201)
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :n)
          expect(fetched_cell).to_not be_nil
        end

        it 'returns a cell at a valid x/y coordinate' do
          cell = gol2_controller.send(:create_seed_cell_at, 200, 201)
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :n)
          expect(fetched_cell.x_loc).to eq 200
          expect(fetched_cell.y_loc).to eq 200
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :s)
          expect(fetched_cell.x_loc).to eq 200
          expect(fetched_cell.y_loc).to eq 202
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :e)
          expect(fetched_cell.x_loc).to eq 201
          expect(fetched_cell.y_loc).to eq 201
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :w)
          expect(fetched_cell.x_loc).to eq 199
          expect(fetched_cell.y_loc).to eq 201
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :nw)
          expect(fetched_cell.x_loc).to eq 199
          expect(fetched_cell.y_loc).to eq 200
          fetched_cell = gol2_controller.fetch_a_cell_for(cell, :w)
          expect(fetched_cell.x_loc).to eq 199
          expect(fetched_cell.y_loc).to eq 201
        end
      end
    end
  end

  context 'when a cell is living' do
    it '#create_surrounding_cells_for will ensure there are active cells surrounding it' do
      cell = gol2_controller.create_seed_cell_at(100, 100)
      gol2_controller.create_surrounding_cells_for(cell)
      expect(cell.all_neighbors.length).to eq 8
    end
  end

  context 'when a cell dies' do
    it '#move_cell_to_reserve if it has no living neighbors' do
      cell = gol2_controller.create_seed_cell_at(100, 100)
      expect(gol2_controller.reserve_cells.length).to eq 0
      gol2_controller.move_cell_to_reserve(cell)
      expect(gol2_controller.reserve_cells.length).to eq 1
    end
  end


  context 'when seeding' do
    it '#seed_viable_cell_group creates a group of cells capable of growing' do
      seed_cell = gol2_controller.send(:seed_viable_cell_group)
      expect(seed_cell).to_not be_nil
      expect(seed_cell.live_neighbors.length).to eq 2
    end

    it '#seed_universe with 1 seed creates the correct number of cells' do
      gol2_controller.seed_universe(1, Gol2::GameController::SEED_TYPE[:random])
      expect(gol2_controller.active_cells.length).to eq 9
      expect(gol2_controller.reserve_cells.length).to eq 0
    end

    context 'and after one generation' do
      it 'will have generated additional cells' do
        gol2_controller.seed_universe(1, Gol2::GameController::SEED_TYPE[:random])
        active_cells = gol2_controller.get_active_cells.length
        gol2_controller.update_game
        expect(gol2_controller.get_active_cells.length).to be > active_cells
      end
    end
  end
end
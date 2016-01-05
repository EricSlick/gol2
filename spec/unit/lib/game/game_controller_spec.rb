require 'spec_helper'

describe Gol2::GameController do
  let(:gol2_controller){ Gol2::GameController}

  context "given a GameController class" do
  end

  context "given a game controller instance"  do
    it 'can seed the universe' do
      gol2_controller.seed_universe(1, Gol2::GameController::SEED_TYPE[:random])
      expect(gol2_controller.active_cells.length).to be > 8
      expect(gol2_controller.reserve_cells.length).to eq 0
    end
  end

end
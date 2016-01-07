require 'spec_helper'

describe Gol2::GameWindow do
  let(:gol2_window) { Gol2::GameWindow.new }

  it 'can create a gosu window' do
    expect(gol2_window.methods).to include(:show, :update, :draw)
  end

  it 'can show a window and shutdown' do
    gol2_window.shutdown = true
    gol2_window.show
    expect(gol2_window.exit_code).to eq(1)
  end

  it 'can shutdown at a specified time in the future' do
    gol2_window.shutdown_in = gol2_window.game_clock + 100 #ms
    gol2_window.show
    expect(gol2_window.game_clock).to be_between(100, 200)
  end

  context "#update_loop" do
    before :each do
      gol2_window.shutdown = true
      gol2_window.show
    end

    it 'updates the game_clock' do
      expect(gol2_window.game_clock).to be > 0
    end

    it 'updates delta time' do
      expect(gol2_window.delta_time).to be > 0
    end

    it 'updates update_clock' do
      expect(gol2_window.update_clock). to eq(Gol2::GameWindow::UPDATE_DELAY)
    end
  end

  context "update game" do
    before :each do
      gol2_window.shutdown_in = 100
      gol2_window.show
    end

    it 'runs the game update' do
      expect(gol2_window.game_loop).to eq 1
    end

  end
end
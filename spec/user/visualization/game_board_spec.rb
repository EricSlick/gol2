require 'spec_helper'

describe Gol2::GameWindow do
  let(:gol2_window) { Gol2::GameWindow.new }

  it 'can create a game window' do
    expect(gol2_window.methods).to include(:show, :update, :draw)
  end

  it 'can show a window and shutdown' do
    gol2_window.shutdown = true
    gol2_window.show
    expect(gol2_window.exit_code).to eq(1)
  end
end
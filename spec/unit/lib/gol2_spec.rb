require 'spec_helper'

describe Gol2 do
  it 'has a version number' do
    expect(Gol2::VERSION).not_to be nil
  end

  it 'has a game loop' do
    Gol2.run
    sleep 0.1 # pause long enough for child process to finish starting up
    expect(Gol2.running?).to eq(true)
    sleep 0.1 # pause long enough for the child process to exit
    expect(Gol2.running?).to eq(false)
  end

end

require 'spec_helper'

describe Gol2 do
  let(:skip_ui){true}

  it 'has a version number' do
    expect(Gol2::VERSION).not_to be nil
  end

  it 'has a game loop' do
    Gol2.run(skip_ui)
    expect(Gol2.running?).to eq(true)
    index = 0
    until(!Gol2.running?) do
      sleep 0.1
      index += 1
      break if index > 20
    end
    sleep 0.2 # pause long enough for the child process to exit
    expect(Gol2.running?).to eq(false)
  end

end

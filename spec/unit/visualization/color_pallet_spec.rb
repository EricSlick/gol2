require 'spec_helper'

describe Gol2::ColorPallet do
  let!(:color_pallet){Gol2::ColorPallet.new}
  it 'returns a color pallet' do
    pallet = color_pallet.generate(8, 4)
    expect(pallet.size * pallet.first.last.size).to eq 32
  end
end
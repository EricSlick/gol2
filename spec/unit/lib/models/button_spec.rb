describe Gol2::Button do
  let(:button){Gol2::Button.new(100, 120, 50, 50)}

  it 'returns an up_state image' do
    expect(button.up_state).to eq "default_up_state.png"
  end
end
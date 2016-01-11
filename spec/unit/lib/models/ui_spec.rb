describe Gol2::UIBase do
  let(:options){{
      x: 10, y: 15, w: 100, h: 40, c: 0xff00ffff
  }}
  let(:ui_element){Gol2::UIBase.new(options)}

  it 'can determine if an x/y coordinate' do

    expect(ui_element.contains?(10, 15)).to be true
    expect(ui_element.contains?(110, 55)).to be true
    expect(ui_element.contains?(45, 42)).to be true
    expect(ui_element.contains?(9, 27)).to be false
    expect(ui_element.contains?(111, 27)).to be false
    expect(ui_element.contains?(10, 14)).to be false
    expect(ui_element.contains?(10, 56)).to be false
  end

  it 'has a hover_state' do
    expect(ui_element.hover_state.value).to eq(0.8)
    expect(ui_element.hover_state.saturation).to be_within(0.1).of(0.8)
  end

  it 'has an up_state' do
    expect(ui_element.up_state.value).to eq(1)
    expect(ui_element.up_state.saturation).to eq(1)
  end

  it 'has a down_state' do
    expect(ui_element.down_state.value).to be_within(0.1).of(0.6)
    expect(ui_element.down_state.saturation).to be_within(0.1).of(0.6)
  end

end
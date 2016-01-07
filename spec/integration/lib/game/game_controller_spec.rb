describe "Integration of #{Gol2::GameController.name} with #{Gol2::GameWindow.name}" do
  let(:gol2_controller){ Gol2::GameController}

  context "a game_controller runs a game window" do

    before :each do
      gol2_controller.reset
    end

    it 'has a game window' do
      expect(gol2_controller.game_width).to be > 100
      expect(gol2_controller.game_height).to be > 100
    end

    it 'can run the game' do
      gol2_controller.skip_visualization = true
      expect(gol2_controller.run).to eq true
    end

    it "creates and runs a valid game window" do
      gol2_controller.skip_visualization = false
      gol2_controller.run({shutdown_in: 100})
      expect(gol2_controller.game_window.game_clock).to be > 0
    end

    it "runs a game and creates new generations" do
      gol2_controller.skip_visualization = false
      gol2_controller.run({shutdown_at_generation: 3})
      expect(gol2_controller.game_window.game_loop).to eq(3)
      expect(gol2_controller.generations).to eq(3)
    end
  end
end
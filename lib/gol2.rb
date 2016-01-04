require "gol2/version"
require "models/cell"
require "game/game"
require "visualization/game_window"

module Gol2
  def self.running?
    @gol_running == true
  end

  # fork a child process to handle the running of the game of life
  def self.run(skip_ui = false)
    @read_from_fork, @write_to_parent = IO.pipe
    @read_from_parent, @write_to_fork = IO.pipe
    @gol_running = true

    @pid = fork do
      # fork doesn't read from or write to itself
      @running = true
      @read_from_fork.close
      @write_to_fork.close

      game = Gol2::Game.new
      game.run

      # trap(:CLD) below is called when this child fork ends.
      sleep 0.1
    end

    # parent doesn't read from or write to itself
    @read_from_parent.close
    @write_to_parent.close

    create_child_exit_trap
  end

  def self.create_child_exit_trap
    # To ensure CLD will not call flush for #puts call
    $stdout.sync = true

    trap(:CLD) do  |x|
      @gol_running = false
      begin
        child_pid = Process.wait(-1, Process::WNOHANG)     # todo: store process running status in hash for multi runs
      rescue Errno::ECHILD
      end
    end
  end
end


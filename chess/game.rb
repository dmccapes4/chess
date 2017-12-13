require_relative "board"
require_relative "display"
require_relative "player"
require 'byebug'

class Game

  def initialize(name1, name2)
    @board = Board.new
    @display = Display.new(@board)
    @player1 = HumanPlayer.new(name1, @display, :white)
    @player2 = HumanPlayer.new(name2, @display, :black)
    @current_player = @player1
  end

  def play
    @display.render
    notify_players
    #byebug
    until @board.checkmate?(@current_player.color)
      begin
        move = @current_player.make_move
        notify_players
        @board.move_piece!(move[0], move[1])
      rescue InvalidMoveError
        retry
      end
      @display.render
      notify_players
      swap_turn!
    end
    puts "#{@current_player.name} loses"
    swap_turn!
    puts "#{@current_player.name} wins"
  end

  private

  def notify_players
    puts "#{@current_player.name} make your move"
  end

  def swap_turn!
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new("Steven", "Dylan").play
end

require_relative "display"
require 'byebug'

class Player
  attr_reader :name, :color

  def initialize(name, display, color)
    @name = name
    @display = display
    @color = color
  end

  def make_move
  end
end

class HumanPlayer < Player
  def make_move
    from_pos = []
    to_pos = []
    while from_pos.empty?
      input = @display.cursor.get_input
      #raise "Not your piece" unless @display.board[input].color == @color
      @display.render
      if input == :tab
        from_pos = @display.cursor.cursor_pos
      end
    end
    while to_pos.empty?
      input = @display.cursor.get_input
      @display.render
      if input == :tab
        to_pos = @display.cursor.cursor_pos
      end
    end
    [from_pos, to_pos]
  end
end

class ComputerPlayer < Player
  def make_move

  end
end

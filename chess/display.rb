require_relative "cursorable"
require_relative "board"
require "colorize"

WHITE_SYMBOLS = {
  king: "\u2654",
  queen: "\u2655",
  rook: "\u2656",
  bishop: "\u2657",
  knight: "\u2658",
  pawn: "\u2659"
}

BLACK_SYMBOLS = {
  king: "\u265A",
  queen: "\u265B",
  rook: "\u265C",
  bishop: "\u265D",
  knight: "\u265E",
  pawn: "\u265F"
}

class Display
  attr_accessor :cursor, :board

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], @board)
  end

  def move(piece)

  end

  def render
    system("clear")
    @board.grid.each_with_index do |row, idx|
      row.each_with_index do |el, jdx|
        if el.color == :white
          if @cursor.cursor_pos == [idx, jdx]
            print "#{WHITE_SYMBOLS[el.symbol].red} "
          else
            print "#{WHITE_SYMBOLS[el.symbol]} "
          end
        elsif el.color == :black
          if @cursor.cursor_pos == [idx, jdx]
            print "#{BLACK_SYMBOLS[el.symbol].red} "
          else
            print "#{BLACK_SYMBOLS[el.symbol]} "
          end
        else
          if @cursor.cursor_pos == [idx, jdx]
            print "\u25FB ".red
          else
            print "\u25FB "
          end
        end
      end
      print "\n"
    end
  end

end

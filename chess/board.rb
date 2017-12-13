require_relative "piece"
require_relative "display"
require "byebug"


class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @null_piece = NullPiece.instance
    make_starting_grid
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def dup
    board_copy = Board.new
    board_copy.grid.each_with_index do |row, idx|
      row.each_index do |jdx|
        case board_copy[[idx, jdx]].symbol
        when :king
          board_copy[[idx, jdx]] = King.new([idx, jdx], self[[idx, jdx]].color)
          board_copy[[idx, jdx]].symbol = self[[idx, jdx]].symbol
        when :queen
          board_copy[[idx, jdx]] = Queen.new([idx, jdx], self[[idx, jdx]].color)
          board_copy[[idx, jdx]].symbol = self[[idx, jdx]].symbol
        when :knight
          board_copy[[idx, jdx]] = Knight.new([idx, jdx], self[[idx, jdx]].color)
          board_copy[[idx, jdx]].symbol = self[[idx, jdx]].symbol
        when :bishop
          board_copy[[idx, jdx]] = Bishop.new([idx, jdx], self[[idx, jdx]].color)
          board_copy[[idx, jdx]].symbol = self[[idx, jdx]].symbol
        when :rook
          board_copy[[idx, jdx]] = Rook.new([idx, jdx], self[[idx, jdx]].color)
          board_copy[[idx, jdx]].symbol = self[[idx, jdx]].symbol
        when :pawn
          board_copy[[idx, jdx]] = Pawn.new([idx, jdx], self[[idx, jdx]].color)
          board_copy[[idx, jdx]].symbol = self[[idx, jdx]].symbol
        when :null
          board_copy[[idx, jdx]] = @null_piece
        end
      end
    end
    board_copy
  end

  def move_piece!(from_pos, to_pos)
    begin
      if self[from_pos].valid_moves(self).include?(to_pos)
        self[from_pos].location = to_pos
        self[from_pos], self[to_pos] = @null_piece, self[from_pos]
      else
        raise InvalidMoveError.new
      end
    rescue InvalidMoveError
      puts "Invalid Move"
      # retry
    end
  end

  def checkmate?(color)
    if check?(find_king(color))
      board_copy = dup
      king = board_copy.find_king(color)
      board_copy.get_pieces(color) do |piece|
        piece.valid_moves(board_copy).each do |move|
          loc = piece.location
          board_copy.move_piece!(loc, move)
          return false unless board_copy.check?(king)
          board_copy.move_piece!(move, loc)
        end
      end
      return true
    end
    false
  end

  def check?(king)
    other_color = (king.color == :white ? :black : :white)
    other_pieces = get_pieces(other_color)
    other_pieces.each do |piece|
      piece.valid_moves(self).each do |move|
        return true if move == king.location
      end
    end
    false
  end


  def get_pieces(color)
    @grid.flatten.select { |piece| piece.color == color }
  end

  protected
  def make_starting_grid
    @grid.each_with_index do |row, idx|
      case idx
      when 0
        row.each_index do |jdx|
          case jdx
          when 0, 7
            self[[idx, jdx]] = Rook.new([idx, jdx], :white)
          when 1, 6
            self[[idx, jdx]] = Knight.new([idx, jdx], :white)
          when 2, 5
            self[[idx, jdx]] = Bishop.new([idx, jdx], :white)
          when 3
            self[[idx, jdx]] = King.new([idx, jdx], :white)
          when 4
            self[[idx, jdx]] = Queen.new([idx, jdx], :white)
          end
        end
      when 1
        row.each_index { |jdx| self[[idx, jdx]] = Pawn.new([idx, jdx], :white) }
      when 6
        row.each_index { |jdx| self[[idx, jdx]] = Pawn.new([idx, jdx], :black) }
      when 7
        row.each_index do |jdx|
          case jdx
          when 0, 7
            self[[idx, jdx]] = Rook.new([idx, jdx], :black)
          when 1, 6
            self[[idx, jdx]] = Knight.new([idx, jdx], :black)
          when 2, 5
            self[[idx, jdx]] = Bishop.new([idx, jdx], :black)
          when 3
            self[[idx, jdx]] = King.new([idx, jdx], :black)
          when 4
            self[[idx, jdx]] = Queen.new([idx, jdx], :black)
          end
        end
      else
        row.each_index { |jdx| self[[idx, jdx]] = @null_piece }
      end
    end
  end

  def find_king(color)
    @grid.flatten.select { |piece| piece.symbol == :king && piece.color == color }.first
  end

end

class InvalidMoveError < StandardError
  def message
    puts "You can't move there!"
  end
end

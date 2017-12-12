require_relative "piece"


class Board

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

  def dup()

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

  def checkmate?

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

  end

end

class InvalidMoveError < StandardError
  def message
    puts "You can't move there!"
  end
end

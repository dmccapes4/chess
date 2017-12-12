require "singleton"
require 'byebug'

module Stepable
  def valid_moves(board)
    moves(board).map do |diff|
      x = @location[0] + diff[0]
      y = @location[1] + diff[1]
      [x, y]
    end
  end

  def is_valid_move?(board, move_diff)
    x = @location[0] + move_diff[0]
    y = @location[1] + move_diff[1]
    return false if x < 0 || x > 7
    return false if y < 0 || y > 7
    return false if board[[x, y]].color == @color
    true
  end

  def moves(board)
    move_diffs.select do |diff|
      is_valid_move?(board, diff)
    end
  end

  private
  def move_diffs
    []
  end
end


module Slideable
  def valid_moves(board)
    result = []
    move_dirs.each do |dir|
      result += grow_unblocked_moves_in_dir(board, dir)
    end
    result
  end

  private
  def move_dirs
    []
  end

  def horizontal_dirs
    [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end

  def diagonal_dirs
    [[1, 1], [1, -1], [-1, -1], [-1, 1]]
  end

  def grow_unblocked_moves_in_dir(board, dir)
    result = []
    i = 1
    pos = [@location[0] + dir[0] * i, @location[1] + dir[1] * i]
    until collision?(board, pos)
      result << pos
      i += 1
      pos = [@location[0] + dir[0] * i, @location[1] + dir[1] * i]
    end
    unless board[pos].nil?
      result << pos unless board[pos].color == @color
    end
    result
  end
end


class Piece

  attr_reader :symbol, :color
  attr_accessor :location

  def initialize(location = nil, color = nil)
    @location = location
    @color = color
  end

  def to_s
    "#{@color} #{@symbol}"
  end

  def empty?
    return true if @symbol == :null
  end

  def collision?(board, pos)
    x, y = pos
    return true if (x < 0 || x > 7) || (y < 0 || y > 7)
    return false if board[pos].symbol == :null
    true
  end

  private
  def move_into_check(to_pos)

  end

end


class King < Piece
  include Stepable

  def initialize(location, color)
    super(location, color)
    @symbol = :king
  end


  protected
  def move_diffs
    [[0, 1], [1, 1], [1, 0], [1, -1],
    [0, -1], [-1, 0], [-1, -1], [-1, 1]]
  end
end


class Queen < Piece
  include Slideable
  def initialize(location, color)
    super(location, color)
    @symbol = :queen
  end

  protected
  def move_dirs
    horizontal_dirs + diagonal_dirs
  end
end


class Knight < Piece
  include Stepable
  def initialize(location, color)
    super(location, color)
    @symbol = :knight
  end

  protected
  def move_diffs
    [[1, 2], [2, 1], [2, -1], [1, -2],
    [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end


class Bishop < Piece
  include Slideable
  def initialize(location, color)
    super(location, color)
    @symbol = :bishop
  end
  protected
  def move_dirs
    diagonal_dirs
  end
end


class Rook < Piece
  include Slideable
  def initialize(location, color)
    super(location, color)
    @symbol = :rook
  end
  protected
  def move_dirs
    horizontal_dirs
  end
end


class Pawn < Piece
  def initialize(location, color)
    super(location, color)
    @symbol = :pawn
  end

  def valid_moves(board)
    # require "byebug"
    # byebug
    moves = []
    pos = [@location[0] + forward_dir[0], @location[1] + forward_dir[1]]
    moves << pos unless collision?(board, pos)
    pos = [@location[0] + forward_step[0], @location[1] + forward_step[1]]
    if !moves.empty? && at_start_row?
      moves << pos unless collision?(board, pos)
    end
    side_attacks.each do |dir|
      pos = [@location[0] + dir[0], @location[1] + dir[1]]
      moves << pos if board[pos].color != @color
    end
    moves
  end

  protected
  def at_start_row?
    case @color
    when :white
      return @location[0] == 1
    when :black
      return @location[0] == 6
    end
  end

  def forward_dir
    case @color
    when :white
      [1, 0]
    when :black
      [-1, 0]
    end
  end

  def forward_step
    case @color
    when :white
      [2, 0]
    when :black
      [-2, 0]
    end
  end

  def side_attacks
    case @color
    when :white
      [[1, 1], [1, -1]]
    when :black
      [[-1, 1], [-1, -1]]
    end
  end
end


class NullPiece < Piece
  include Singleton
  def initialize
    super
    @symbol = :null
  end

  def valid_moves(board)
    []
  end
end

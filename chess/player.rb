require_relative "display"

class Player
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

  end
end

class ComputerPlayer < Player
  def make_move
    
  end
end

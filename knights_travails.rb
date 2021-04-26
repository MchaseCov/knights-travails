# frozen_string_literal: true

# for tracking and updating position of knight
class NodeMover
  attr_reader :position, :parent

  # possible moves a knight piece can move (relative to [0, 0])
  MOVES = [
    [1, 2], [1, -2], [2, 1], [2, -1],
    [-1, 2], [-1, -2], [-2, 1], [-2, -1]
  ].freeze

  # History variable updates to track already used moves to not backtrack or loop
  @@history = []

  # initialize function to log the current position, parent, and push current to history
  def initialize(position, parent)
    @position = position
    @parent = parent
    @@history.push(position)
  end

  # a move is valid if it is contained in the chessboard (1,1 to 8,8)
  def self.valid?(position)
    position[0].between?(1, 8) && position[1].between?(1, 8)
  end

  # uses the MOVES constant to update the postiion of the knight, provided it's a valid square and not in the history
  # then starts a new instance of NodeMover using the new position as the position and the previous one as the parent
  def next_moves
    MOVES.map { |move| [(position[0] + move[0]), (position[1] + move[1])] }
         .keep_if { |move| NodeMover.valid?(move) }
         .reject { |move| @@history.include?(move) }
         .map { |move| NodeMover.new(move, self) }
  end
end

# prints the parent to the console. Nil will not be printed. 
def print_parent(pos)
  print_parent(pos.parent) unless pos.parent.nil?
  print pos.position
end

# takes in start and end. Runs nodemover using the start as the initial position. Parent is nil because this is the first step
# until your start input matches your end input, will use the next_moves method for each move and add to queue.
# After the correct solution is found, the parents of the successful chain is printed to the console using the print_parent method
def knight_moves(start_pos, end_pos)
  queue = []
  current_pos = NodeMover.new(start_pos, nil)
  until current_pos.position == end_pos
    current_pos.next_moves.each { |move| queue.push(move) }
    current_pos = queue.shift
  end
  print_parent(current_pos)
end

knight_moves([1, 3], [1, 5])

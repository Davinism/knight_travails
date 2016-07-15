require_relative "../polytree/lib/00_tree_node.rb"
require "byebug"

class KnightPathFinder
  SIZE_OF_BOARD = 8

  def self.valid_moves(pos)
    results_arr = []
    row, col = pos

    results_arr =  [[row-2, col+1],
                    [row-1, col+2],
                    [row+1, col+2],
                    [row+2, col+1],
                    [row+2, col-1],
                    [row+1, col-2],
                    [row-1, col-2],
                    [row-2, col-1]]

    results_arr.select { |pos| valid_pos?(pos)}
  end

  def self.valid_pos?(pos)
    pos.all? {|value| value.between?(0, SIZE_OF_BOARD - 1) }
  end

  def initialize(start_pos)
    @start_pos = start_pos
    @visited_positions = [start_pos]
    @move_tree = build_move_tree
  end

  def build_move_tree
    root = PolyTreeNode.new(start_pos)
    queue = [root]
    until queue.empty?
      current_parent = queue.shift

      new_positions = new_move_positions(current_parent.value)
      new_positions.each do |pos|
        node = PolyTreeNode.new(pos)
        current_parent.add_child(node)
        node.parent = current_parent

        queue << node
      end
    end

    root
  end

  def new_move_positions(pos)
    new_positions = self.class.valid_moves(pos).reject { |pos| visited_positions.include?(pos) }
    @visited_positions.concat(new_positions)
    new_positions
  end

  def find_path(pos)
    end_node = move_tree.dfs(pos)
    trace_path_back(end_node)
  end

  def trace_path_back(node)
    return [node.value] if node.parent.nil?
    trace_path_back(node.parent) + [node.value]
  end

  private
  attr_reader :start_pos, :visited_positions, :move_tree


end

if __FILE__ == $PROGRAM_NAME
  n = KnightPathFinder.new([0,0])
  p n.find_path([7, 6])
  p n.find_path([6, 2])
end

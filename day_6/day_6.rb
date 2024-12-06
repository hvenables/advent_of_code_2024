inputs = File.read("input.txt")
# inputs = <<~INPUT
#   ....#.....
#   .........#
#   ..........
#   ..#.......
#   .......#..
#   ..........
#   .#..^.....
#   ........#.
#   #.........
#   ......#...
# INPUT

grid = inputs.split("\n").map { _1.split("") }
row_length = grid[0].length
pad_row = Array.new(row_length) { "Y" }
grid = grid.unshift(pad_row.dup)
grid = grid.push(pad_row.dup)
grid.each do |row|
  row.unshift("Y")
  row.push("Y")
end

start_coord = grid.each_with_index do |row, y|
  coord = row.map.with_index do |coord, x|
    if coord == "^"
      [y, x]
    end
  end

  break coord.compact.flatten if coord.compact.any?
end

class PathTraverser
  MOVEMENT = {
    "^" => [-1, 0],
    ">" => [0, 1],
    "v" => [1, 0],
    "<" => [0, -1]
  }

  ROTATE = {
    "^" => ">",
    ">" => "v",
    "v" => "<",
    "<" => "^"
  }

  attr_reader :visited, :grid

  def initialize(grid, start_coord, direction)
    @grid = grid
    @start_coord = start_coord
    @direction = direction
    @visited = Set.new
  end

  def traverse
    coord = @start_coord
    @grid[coord[0]][coord[1]] = '0'

    until finished?(coord)
      @visited << coord
      @grid[coord[0]][coord[1]] = "X" unless @grid[coord[0]][coord[1]] == "0"

      coord = move(coord)
    end
  end

  private

  def move(coord)
    new_coord = [coord[0] + MOVEMENT[@direction][0], coord[1] + MOVEMENT[@direction][1]]
    new_pos = @grid[new_coord[0]]&.[](new_coord[1])

    if new_pos == '#'
      @direction = ROTATE[@direction]
      new_coord = move(coord)
    end

    new_coord
  end

  def finished?(coord)
    @grid[coord[0]][coord[1]] == "Y"
  end
end

traverser = PathTraverser.new(grid, start_coord, "^")
traverser.traverse

puts "Visited locations: #{traverser.visited.count}"


class LoopMaker
  MOVEMENT = {
    "^" => [-1, 0],
    ">" => [0, 1],
    "v" => [1, 0],
    "<" => [0, -1]
  }

  ROTATE = {
    "^" => ">",
    ">" => "v",
    "v" => "<",
    "<" => "^"
  }

  def initialize(grid, start_coord, visited)
    @grid = grid
    @start_coord = start_coord
    @direction = "^"
    @visited = visited
  end

  def count_loops
    @visited.count do |visited_coord|
      next if visited_coord == @start_coord

      new_grid = @grid.map(&:dup)
      new_grid[visited_coord[0]][visited_coord[1]] = '#'

      check_for_loop?(new_grid)
    end
  end

  private

  def check_for_loop?(new_grid)
    visited_with_dir = Set.new
    @direction = "^"
    coord = @start_coord

    loop do
      return true if loop_detected?(coord, visited_with_dir)
      return false if finished?(coord, new_grid)

      visited_with_dir << [coord, @direction]

      coord = move(coord, new_grid)
    end
  end

  def move(coord, grid)
    new_coord = [coord[0] + MOVEMENT[@direction][0], coord[1] + MOVEMENT[@direction][1]]
    new_pos = grid[new_coord[0]]&.[](new_coord[1])

    if new_pos == '#'
      @direction = ROTATE[@direction]
      new_coord = move(coord, grid)
    end

    new_coord
  end

  def loop_detected?(coord, visited_with_dir)
    visited_with_dir.include?([coord, @direction])
  end

  def finished?(coord, grid)
    grid[coord[0]][coord[1]] == "Y"
  end
end

loop_maker = LoopMaker.new(grid, start_coord, traverser.visited)
puts "Number of loops: #{loop_maker.count_loops}"

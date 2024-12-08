inputs = File.read("input.txt")
# inputs = <<~INPUT
# ............
# ........0...
# .....0......
# .......0....
# ....0.......
# ......A.....
# ............
# ............
# ........A...
# .........A..
# ............
# ............
# INPUT
# inputs = <<~INPUT
# T.........
# ...T......
# .T........
# ..........
# ..........
# ..........
# ..........
# ..........
# ..........
# ..........
# INPUT

grid = inputs.split("\n").map { _1.split("") }
antinode_grid = Array.new(grid.length) { Array.new(grid[0].length) }

max_y = grid.length - 1
max_x = grid[0].length - 1

antenna = {}

grid.each_with_index do |row, y|
  row.each_with_index do |coord, x|
    next if coord == "."

    antenna[coord] ||= []
    antenna[coord] << [y, x]
  end
end

antenna.each do |_name, locations|
  locations.permutation(2) do |first, second|
    dy = -(first[0] - second[0])
    dx = -(first[1] - second[1])

    antinode = [second[0] + dy, second[1] + dx]
    next if (antinode[0] > max_y || antinode[0].negative?)
    next if (antinode[1] > max_x || antinode[1].negative?)

    antinode_grid[antinode[0]][antinode[1]] = '#'
  end
end

result = antinode_grid.flatten.compact.count
puts "Number of antinodes: #{result}"

antenna.each do |_name, locations|
  locations.permutation(2) do |first, second|
    dy = -(first[0] - second[0])
    dx = -(first[1] - second[1])

    antinodes = []
    antinode = [second[0], second[1]]

    loop do
      break if (antinode[0] > max_y || antinode[0].negative?)
      break if (antinode[1] > max_x || antinode[1].negative?)

      antinodes << antinode
      antinode = [antinode[0] + dy, antinode[1] + dx]
    end

    antinodes.each do |an|
      antinode_grid[an[0]][an[1]] = '#'
    end
  end
end

result_2 = antinode_grid.flatten.compact.count
puts "Result with resonance: #{result_2}"

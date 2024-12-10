inputs = File.read("input.txt")
# inputs = <<~INPUT
# 89010123
# 78121874
# 87430965
# 96549874
# 45678903
# 32019012
# 01329801
# 10456732
# INPUT

grid = inputs.split("\n").map { _1.split("").map(&:to_i) }

trail_starts = []

grid.each_with_index do |row, y|
  row.each_with_index do |pos, x|
    if pos == 0
      trail_starts << [y, x]
    end
  end
end

DIRECTIONS = [
  [-1, 0],
  [0, 1],
  [1, 0],
  [0, -1]
]

trail_counts = trail_starts.map do |trail_start|
  paths = [[trail_start]]
  trails = []

  while paths.any?
    current_path = paths.shift
    current_pos = current_path[-1]
    current_num = grid[current_pos[0]][current_pos[1]]

    if current_num == 9
      trails << current_path

      next
    end

    DIRECTIONS.each do |y, x|
      new_coord = [current_pos[0] + y, current_pos[1] + x]
      next if new_coord.any?(&:negative?)
      new_num = grid[new_coord[0]]&.[](new_coord[1])
      next if new_num.nil?

      if new_num == (current_num + 1)
        new_path = current_path.dup << new_coord
        paths << new_path
      end
    end
  end

  [trails.map(&:last).uniq.count, trails.count]
end

puts "Result for part 1: #{trail_counts.map(&:first).sum}"
puts "Result for part 2: #{trail_counts.map(&:last).sum}"

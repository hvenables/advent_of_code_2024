inputs = File.read("input.txt")
# inputs = <<~INPUT
# ########
# #..O.O.#
# ##@.O..#
# #...O..#
# #.#.O..#
# #...O..#
# #......#
# ########
#
# <^^>>>vv<v>>v<<
# INPUT
#
# inputs = <<~INPUT
# ##########
# #..O..O.O#
# #......O.#
# #.OO..O.O#
# #..O@..O.#
# #O#..O...#
# #O..O..O.#
# #.OO.O.OO#
# #....O...#
# ##########
#
# <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
# vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
# ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
# <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
# ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
# ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
# >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
# <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
# ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
# v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
# INPUT

DIRECTIONS = {
  "<" => [-1, 0],
  "^" => [0, -1],
  ">" => [1, 0],
  "v" => [0, 1]
}

layout, dirs = inputs.split("\n\n")

layout = layout.split("\n").map { _1.split("") }
dirs = dirs.gsub("\n", "").split("")

robot = layout.each_with_index do |row, y|
  found_row = row.each_with_index.find do |coord, x|
    coord == "@"
  end

  break [found_row.last, y] if found_row
end

def move_box(layout, location, direction)
  new_location = [location[0] + direction[0], location[1] + direction[1]]
  new_pos = layout[new_location[1]][new_location[0]]

  case new_pos
  when "."
    layout[new_location[1]][new_location[0]] = "O"
  when "O"
    if move_box(layout, new_location, direction)
      layout[new_location[1]][new_location[0]] = "O"
    end
  end
end

dirs.each do |dir|
  direction = DIRECTIONS[dir]
  new_location = [robot[0] + direction[0], robot[1] + direction[1]]
  new_pos = layout[new_location[1]][new_location[0]]

  case new_pos
  when "."
    layout[robot[1]][robot[0]] = "."
    layout[new_location[1]][new_location[0]] = "@"
    robot = new_location
  when "O"
    if move_box(layout, new_location, direction)
      layout[robot[1]][robot[0]] = "."
      layout[new_location[1]][new_location[0]] = "@"
      robot = new_location
    end
  end
end

result = layout.each_with_index.sum do |row, y|
  row.each_with_index.sum do |coord, x|
    case coord
    when "O"
      (100 * y) + x
    else
      0
    end
  end
end

puts "Part 1 result: #{result}"

layout, dirs = inputs.split("\n\n")

layout = layout.split("\n").map { _1.split("") }
dirs = dirs.gsub("\n", "").split("")

new_layout = []
layout.each_with_index do |row, y|
  new_layout[y] = []
  row.each_with_index do |coord, x|
    new_x = x * 2

    case coord
    when "#"
      new_layout[y][new_x] = '#'
      new_layout[y][new_x + 1] = '#'
    when "O"
      new_layout[y][new_x] = '['
      new_layout[y][new_x + 1] = ']'
    when "@"
      new_layout[y][new_x] = '@'
      new_layout[y][new_x + 1] = '.'
    when "."
      new_layout[y][new_x] = '.'
      new_layout[y][new_x + 1] = '.'
    end
  end
end

new_robot = new_layout.each_with_index do |row, y|
  found_row = row.each_with_index.find do |coord, x|
    coord == "@"
  end

  break [found_row.last, y] if found_row
end

def move_large_box(layout, box, direction)
  if direction[0].zero?
    move_large_box_vertically(layout, box, direction)
  else
    move_large_box_horizontally(layout, box, direction)
  end
end

def move_large_box_horizontally(layout, box, direction)
  new_location = [
    [box[0][0] + direction[0], box[0][1]],
    [box[1][0] + direction[0], box[1][1]]
  ]
  new_pos = if direction[0].negative?
              layout[new_location[0][1]][new_location[0][0]]
            else
              layout[new_location[1][1]][new_location[1][0]]
            end

  case new_pos
  when "."
    new_location.each_with_index do |location, i|
      layout[location[1]][location[0]] = i.zero? ? "[" : "]"
    end
  when "]", "["
    new_box = [
      [new_location[0][0] + direction[0], new_location[0][1]],
      [new_location[1][0] + direction[0], new_location[1][1]]
    ]
    if move_large_box_horizontally(layout, new_box, direction)
      new_location.each_with_index do |location, i|
        layout[location[1]][location[0]] = i.zero? ? "[" : "]"
      end
    end
  end
end

def move_to_new_location(layout, old_location, new_location)
  old_location.each { layout[_1[1]][_1[0]] = "." }

  new_location.each_with_index do |location, i|
    layout[location[1]][location[0]] = i.zero? ? "[" : "]"
  end
end

def move_large_box_vertically(layout, box, direction)
  new_location = [
    [box[0][0], box[0][1] + direction[1]],
    [box[1][0], box[1][1] + direction[1]]
  ]

  new_positions = [
    layout[new_location[0][1]][new_location[0][0]],
    layout[new_location[1][1]][new_location[1][0]]
  ]

  case new_positions
  when [".", "."]
    move_to_new_location(layout, box, new_location)
  when ["[", "]"]
    if move_large_box_vertically(layout, new_location, direction)
      move_to_new_location(layout, box, new_location)
    end
  when [".", "["]
    next_box = [
      new_location[1],
      [new_location[1][0] + 1, new_location[1][1]]
    ]

    if move_large_box_vertically(layout, next_box, direction)
      move_to_new_location(layout, box, new_location)
    end
  when ["]", "."]
    next_box = [
      [new_location[0][0] - 1, new_location[0][1]],
      new_location[0]
    ]

    if move_large_box_vertically(layout, next_box, direction)
      move_to_new_location(layout, box, new_location)
    end
  when ["]", "["]
    box_1 = [
      [new_location[0][0] - 1, new_location[0][1]],
      new_location[0]
    ]
    box_2 = [
      new_location[1],
      [new_location[1][0] + 1, new_location[1][1]]
    ]
    old_layout = layout.map(&:dup)

    if [box_1, box_2].all? { |b| move_large_box_vertically(layout, b, direction) }
      move_to_new_location(layout, box, new_location)
    else
      old_layout.each_with_index do |row, y|
        row.each_with_index do |coord, x|
          layout[y][x] = coord
        end
      end
      false
    end
  end
end

def move_direction(layout, robot, dir)
  direction = DIRECTIONS[dir]
  new_location = [robot[0] + direction[0], robot[1] + direction[1]]
  new_pos = layout[new_location[1]][new_location[0]]

  case new_pos
  when "."
    layout[robot[1]][robot[0]] = "."
    layout[new_location[1]][new_location[0]] = "@"
    robot = new_location
  when "["
    box = [
      new_location,
      [new_location[0] + 1, new_location[1]]
    ]

    if move_large_box(layout, box, direction)
      layout[robot[1]][robot[0]] = "."
      layout[new_location[1]][new_location[0]] = "@"
      robot = new_location
    else
      robot
    end
  when "]"
    box = [
      [new_location[0] - 1, new_location[1]],
      new_location
    ]

    if move_large_box(layout, box, direction)
      layout[robot[1]][robot[0]] = "."
      layout[new_location[1]][new_location[0]] = "@"
      robot = new_location
    else
      robot
    end
  else
    robot
  end
end

dirs.each do |dir|
  new_robot = move_direction(new_layout, new_robot, dir)
end

result = new_layout.each_with_index.sum do |row, y|
  row.each_with_index.sum do |coord, x|
    case coord
    when "["
      (100 * y) + x
    else
      0
    end
  end
end

puts "Result Part 2: #{result}"

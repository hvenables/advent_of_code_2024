inputs = File.read("input.txt")
# inputs = <<~INPUT
#   MMMSXXMASM
#   MSAMXMSMSA
#   AMXSXMAAMM
#   MSAMASMSMX
#   XMASAMXAMM
#   XXAMMXXAMA
#   SMSMSASXSS
#   SAXAMASAAA
#   MAMMMXMMMM
#   MXMXAXMASX
# INPUT

parsed_input = inputs.split("\n").map { _1.split("") }

class WordSearchSolver
  attr_reader :parsed_input, :found_x
  attr_accessor :num_of_xmas

  def initialize(parsed_input, num_of_xmas)
    @parsed_input = parsed_input
    @num_of_xmas = num_of_xmas || 0
    @found_x = []
  end

  def solve
    parsed_input.each_with_index do |row, y|
      row.each_with_index do |letter, x|
        next unless letter == 'X'

        search_for_m(x, y)
      end
    end
    num_of_xmas
  end

  private

  def search_for_m(x, y)
    [-1, 0, 1].each do |delta_y|
      [-1, 0, 1].each do |delta_x|
        next if delta_y == 0 && delta_x == 0

        new_y = y + delta_y
        new_x = x + delta_x
        if parsed_input[new_y]&.[](new_x) == "M"
          search_for_a(delta_x, delta_y, new_x, new_y)
        end
      end
    end
  end

  def search_for_a(delta_x, delta_y, x, y)
    new_x = x + delta_x
    new_y = y + delta_y

    return if new_x.negative? || new_y.negative?
    if parsed_input[new_y]&.[](new_x) == "A"
      search_for_s(delta_x, delta_y, new_x, new_y)
    end
  end

  def search_for_s(delta_x, delta_y, x, y)
    new_x = x + delta_x
    new_y = y + delta_y

    return if new_x.negative? || new_y.negative?
    if parsed_input[new_y]&.[](new_x) == "S"
      self.num_of_xmas += 1
    end
  end
end

word_search_solver = WordSearchSolver.new(parsed_input, 0)
result = word_search_solver.solve

puts "Number of XMAS: #{result}"

class XmasSolver
  attr_reader :parsed_input
  attr_accessor :count

  DIAGONAL = [
    [[-1, -1], [0, 0], [1, 1]],
    [[1, -1], [0, 0], [-1, 1]]
  ]

  def initialize(parsed_input)
    @parsed_input = parsed_input
    @count = 0
  end

  def solve
    parsed_input.each_with_index do |row, y|
      row.each_with_index do |letter, x|
        next unless letter == 'A'
        next if y.zero? || x.zero?
        next if (y + 1 == row.length) || (x + 1 == row.length)

        result = DIAGONAL.map do |diagonal|
          diagonal.map do |coord|
            parsed_input[y + coord[0]][x + coord[1]]
          end
        end.map(&:sort).map(&:join)

        self.count += 1 if result == ["AMS", "AMS"]
      end
    end

    count
  end
end

xmas_solver = XmasSolver.new(parsed_input)
result_2 = xmas_solver.solve

puts "Number of X-MAS: #{result_2}"

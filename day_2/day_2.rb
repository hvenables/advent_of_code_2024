inputs = File.read("input.txt").split("\n").map { _1.split(" ").map(&:to_i) }

def safe?(input)
  operand = calculate_operand(input[0], input[1])
  return false unless operand

  input.each_cons(2).all? do |first, second|
    difference = (first - second).abs
    first.send(operand, second) && difference > 0 && difference < 4
  end
end

def calculate_operand(first, second)
  if first < second
    "<"
  elsif first > second
    ">"
  end
end

def safe_with_dampener?(input)
  return true if safe?(input)

  input.each_with_index.any? do |_, index|
    new_input = input.dup
    new_input.delete_at(index)
    safe?(new_input)
  end
end

safe_count = inputs.count { |input| safe?(input) }
puts "Safe: #{safe_count}"

safe_with_dampener_count = inputs.count { |input| safe_with_dampener?(input) }
puts "Safe with dampener: #{safe_with_dampener_count}"

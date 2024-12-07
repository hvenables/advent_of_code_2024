inputs = File.read("input.txt")

# inputs = <<~INPUT
# 190: 10 19
# 3267: 81 40 27
# 83: 17 5
# 156: 15 6
# 7290: 6 8 6 15
# 161011: 16 10 13
# 192: 17 8 14
# 21037: 9 7 18 13
# 292: 11 6 16 20
# INPUT

inputs = inputs.each_line.map do |line|
  eq = line.chomp.split(":")
  eq[1] = eq[1].split.map(&:to_i)
  eq[0] = eq[0].to_i
  eq
end

result = inputs.sum do |answer, values|
  answers = [values[0]]
  values[1..].each do |value|
    answers = answers.flat_map { [_1 + value, _1 * value] }
  end

  if answers.include?(answer)
    answer
  else
    0
  end
end

puts "Correct values: #{result}"

result_2 = inputs.sum do |answer, values|
  answers = [values[0]]
  values[1..].each do |value|
    answers = answers.flat_map { [_1 + value, _1 * value, [_1, value].join.to_i] }
  end

  if answers.include?(answer)
    answer
  else
    0
  end
end

puts "Correct values with concatination: #{result_2}"

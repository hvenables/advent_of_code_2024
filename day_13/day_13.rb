inputs = File.read("input.txt")
# inputs = <<~INPUT
# Button A: X+94, Y+34
# Button B: X+22, Y+67
# Prize: X=8400, Y=5400
#
# Button A: X+26, Y+66
# Button B: X+67, Y+21
# Prize: X=12748, Y=12176
#
# Button A: X+17, Y+86
# Button B: X+84, Y+37
# Prize: X=7870, Y=6450
#
# Button A: X+69, Y+23
# Button B: X+27, Y+71
# Prize: X=18641, Y=10279
# INPUT

inputs = inputs.split("\n\n").map { _1.split("\n") }
inputs = inputs.map { _1.map { |a| a.scan(/X[=+](\d*).*Y[=+](\d*)/).flatten.map(&:to_f) } }

# a = ((a1 * y2) - (x2 * a2)) / ((x1 * y2) - (x2 * y1))
# b = ((x1 * a2) - (a2 * y1)) / ((x1 * y2) - (x2 * y1))
result = inputs.sum do |input|
  x1, x2 = input[0]
  y1, y2 = input[1]
  a1, a2 = input[2]

  # a1 += 10000000000000
  # a2 += 10000000000000

  a = ((a1 * y2) - (y1 * a2)) / ((x1 * y2) - (x2 * y1))
  b = ((x1 * a2) - (a1 * x2)) / ((x1 * y2) - (x2 * y1))

  if (a.round == a) && (b.round == b)
    (a * 3) + (b * 1)
  else
    0
  end
end

puts result.to_i

# Had to research cramers rule good video explaining below
# https://www.youtube.com/watch?v=jBsC34PxzoM&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=12

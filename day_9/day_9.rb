inputs = File.read("input.txt")
# inputs = "2333133121414131402"
inputs = inputs.split("").map(&:to_i)

id = 0
free_space = false

memory_with_gaps = []
inputs.each do |num|
  if free_space
    memory_with_gaps << Array.new(num)
    free_space = false
  else
    memory_with_gaps << Array.new(num) { id }
    free_space = true
    id += 1
  end
end

memory_with_gaps = memory_with_gaps.flatten

while (space = memory_with_gaps.index(nil))
  id = memory_with_gaps.pop
  memory_with_gaps[space] = id
end

result =  memory_with_gaps.each_with_index.sum { |n, i| n * i }
puts "Part 1 result: #{result}"

moving_id = memory_with_gaps[-1]

while !moving_id.negative?
  gap_size = memory_with_gaps.count(moving_id)
  id_index = memory_with_gaps.index(moving_id)

  space_index = memory_with_gaps.each_cons(gap_size).with_index.find do |gap, index|
    gap.all?(&:nil?)
  end&.last

  if space_index && space_index < id_index
    gap_size.times do |n|
      memory_with_gaps[id_index + n] = nil
      memory_with_gaps[space_index + n] = moving_id
    end
  end


  moving_id -= 1
end

result = memory_with_gaps.each_with_index.sum do |n, i|
  next 0 if n.nil?

  n * i
end
puts "Part 2 result: #{result_2}"

inputs = File.read("input.txt").split("\n")
list_1 = []
list_2 = []

inputs.each do |input|
  item_1, item_2 = input.split(/\s+/).map(&:to_i)
  list_1 << item_1
  list_2 << item_2
end

list_1.sort!
list_2.sort!

result_1 = list_1.zip(list_2).sum do |item_1, item_2|
  (item_1 - item_2).abs
end

puts "Total Distance: #{result_1}"

list_2_tally = list_2.tally

result_2 = list_1.sum do |item|
  list_2_tally.fetch(item, 0) * item
end

puts "Similarity score: #{result_2}"

inputs = File.read("input.txt")

nums = inputs.scan(/mul\((\d{1,3}),(\d{1,3})\)/)
result_1 = nums.sum do |num_1, num_2|
  num_1.to_i * num_2.to_i
end

puts "Total: #{result_1}"

disables_removed = inputs.gsub(/\n/, '').gsub(/don't\(\).*?(do\(\)|$)/, '')
nums = disables_removed.scan(/mul\((\d{1,3}),(\d{1,3})\)/)
result_2 = nums.sum do |num_1, num_2|
  num_1.to_i * num_2.to_i
end

puts "Total without don't: #{result_2}"

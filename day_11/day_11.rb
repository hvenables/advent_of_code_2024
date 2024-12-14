require 'parallel'

inputs = File.read("input.txt")
# inputs = "125 17"

stones = inputs.split(" ").map(&:to_i)

class StoneCounter
  attr_reader :stones, :remaining_counts

  def initialize(stones, remaining_counts = 5)
    @stones = stones.tally
    @remaining_counts = remaining_counts
  end

  def count
    new_stones = Hash.new { 0 }

    @stones.each do |num, count|
      if num == 0
        new_stones[1] += count
      elsif (s_len = (str = num.to_s).length).even?
        mid = s_len / 2

        new_stones[str[...mid].to_i] += count
        new_stones[str[mid..].to_i] += count
      else
        new_stones[num * 2024] += count
      end
    end

    @stones = new_stones
  end
end

stone_counter = StoneCounter.new(stones)
25.times { stone_counter.count }

puts "Part 1: #{stone_counter.stones.values.sum}"

50.times { stone_counter.count }
puts "Part 2: #{stone_counter.stones.values.sum}"

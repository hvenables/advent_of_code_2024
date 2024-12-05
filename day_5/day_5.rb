inputs = File.read("input.txt")
# inputs = <<~INPUT
# 47|53
# 97|13
# 97|61
# 97|47
# 75|29
# 61|13
# 75|53
# 29|13
# 97|29
# 53|29
# 61|53
# 97|53
# 61|29
# 47|13
# 75|47
# 97|75
# 47|61
# 75|61
# 47|29
# 75|13
# 53|13
#
# 75,47,61,53,29
# 97,61,53,29,13
# 75,29,13
# 75,97,47,61,53
# 61,13,29
# 97,13,75,29,47
# INPUT

page_rules, updates = inputs.split("\n\n")

page_rules = page_rules.split("\n").map { _1.split("|").map(&:to_i) }
pages = {}

page_rules.each do |page_number, before_number|
  page = pages[page_number]
  if page.nil?
    page = pages[page_number] = []
  end
  page << before_number
end

updates = updates.split("\n").map { _1.split(",").map(&:to_i) }

invalid, valid = updates.partition do |update|
  update.each_with_index.any? do |page, index|
    next unless pages[page]

    (update[...index] & pages[page]).any?
  end
end

result = valid.sum do |update|
  middle = update.length / 2
  update[middle]
end
puts "Result: #{result}"

def resort_invalid(update, pages)
  index = 0

  while index < update.length
    page_num = update[index]
    before = pages[page_num]

    next index += 1 if before.nil?

    rule_breaks = (update[...index] & before)
    next index += 1 if rule_breaks.empty?

    rule_break = rule_breaks.first
    update.delete(page_num)
    rule_break_index = update.index(rule_break)
    update.insert(rule_break_index, page_num)
    index = 0
  end

  update
end

fixed_invalid = invalid.map { resort_invalid(_1, pages) }

result_2 = fixed_invalid.sum do |update|
  middle = update.length / 2
  update[middle]
end
puts "Result 2: #{result_2}"

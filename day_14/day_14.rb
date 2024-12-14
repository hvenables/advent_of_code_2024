inputs = File.read("input.txt")
# inputs = <<~INPUT
# p=0,4 v=3,-3
# p=6,3 v=-1,-3
# p=10,3 v=-1,2
# p=2,0 v=2,-1
# p=0,0 v=1,3
# p=3,0 v=-2,-2
# p=7,6 v=-1,-3
# p=3,0 v=-1,-2
# p=9,3 v=2,3
# p=7,3 v=-1,2
# p=2,4 v=2,-3
# p=9,5 v=-3,-3
# INPUT

class Robot
  attr_reader :position, :velocity

  def initialize(position, velocity, grid_width, grid_height)
    @position = position
    @velocity = velocity
    @grid_width = grid_width
    @grid_height = grid_height
  end

  def move
    @position = [
      (@position[0] + @velocity[0]) % @grid_width,
      (@position[1] + @velocity[1]) % @grid_height
    ]
  end
end

robots = inputs.each_line.map do |line|
  pos = line.scan(/p\=(\d+)\,(\d+)/).first.map(&:to_i)
  vel = line.scan(/v\=(\-*\d+)\,(\-*\d+)/).first.map(&:to_i)

  Robot.new(pos, vel, 101, 103)
end

100.times do
  robots.each(&:move)
end

q1 = robots.count { _1.position[0] < 50 && _1.position[1] < 51 }
q2 = robots.count { _1.position[0] > 50 && _1.position[1] < 51 }
q3 = robots.count { _1.position[0] < 50 && _1.position[1] > 51 }
q4 = robots.count { _1.position[0] > 50 && _1.position[1] > 51 }
puts "Part 1: #{q1 * q2 * q3 * q4}"

robots = inputs.each_line.map do |line|
  pos = line.scan(/p\=(\d+)\,(\d+)/).first.map(&:to_i)
  vel = line.scan(/v\=(\-*\d+)\,(\-*\d+)/).first.map(&:to_i)

  Robot.new(pos, vel, 101, 103)
end

n = 0
loop do
  robots.each(&:move)
  n += 1

  middle_robots = robots.count do |r|
    (r.position[0] > 20 && r.position[0] < 80) &&
      (r.position[1] > 20 && r.position[1] < 80)
  end

  if middle_robots > 300
    grid = Array.new(103) { Array.new(101) { 0 } }; robots.each { grid[_1.position[1]][_1.position[0]] += 1 }; grid[35..80].each { p _1[20..60].join };
    puts "Part 2: #{n}"

    break
  end
end




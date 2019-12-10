require 'pry'
require 'json'

class Asteroid
  attr_accessor :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end

  def to_s
    "#{@x},#{@y}"
  end

  def can_see(asteroids)
    angles = {}
    asteroids.each do |coord, asteroid|
      next if asteroid.x == @x && asteroid.y == @y
      angle = Math.atan2(-1*(asteroid.y - @y), asteroid.x - @x) + Math::PI
      angles[angle] ||= []
      angles[angle] << asteroid
    end
    angles
  end

  def can_see_count(asteroids)
    can_see(asteroids).count
  end
end

# input = File.readlines('input')
# input = %w[
# .#..#
# .....
# #####
# ....#
# ...##
# ]
# input = %w[
#   #...
#   ....
#   ..#.
#   ...#
# ]
input = %w[
.#....#####...#..
##...##.#####..##
##...#...#.#####.
..#.....#...###..
..#.#.....#....##
]

# input = input.map{|row| row.chars.map{ |col| col == "#"} }

asteroids = {}
input.each_with_index.map do |row, y|
  row.chars.each_with_index.map do |col, x|
    asteroids["#{x},#{y}"] = Asteroid.new(x,y) if col == "#"
  end
end
binding.pry

seen = asteroids.map do |coord, asteroid|
  [coord, asteroid.can_see_count(asteroids)]
end

puts JSON.generate(seen.max_by{|c,s| s })

# part 1: ["27,19",314]
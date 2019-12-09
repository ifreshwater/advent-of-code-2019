require 'pry'
require 'json'

# input = File.readlines('sample_input').map(&:strip)
input = File.readlines('input').map(&:strip)

def what_orbits(map, key)
  map.select do |orbit| 
    parent, child = orbit.split(')') 
    parent == key
  end
end

class Node
  attr_accessor :name, :parent, :depth
  def initialize(name, parent, depth)
    @name = name
    @parent = parent
    @depth = depth
  end
  
  def to_s
    "#{@name}: parent is #{@parent}, depth is #{@depth}"
  end

  def to_json
    JSON.generate(
      name: @name,
      parent: @parent,
      depth: @depth
    )
  end
end

planets = {}

def build_map(map,planets, parent_node)
  what_orbits(map, parent_node.name).each do |orbit|
    parent, child = orbit.split(')') 
    planets[child] = Node.new(child, parent_node.name, parent_node.depth + 1)
    build_map(map, planets, planets[child])
  end
end

def get_parents(name, planets)
  parents = []
  curr_planet = planets[name]
  while curr_planet.parent != nil
    # binding.pry
    parents << curr_planet.parent
    curr_planet = planets[curr_planet.parent]
  end
  parents
end

# input.each do |orbit|
#   parent, child = orbit.strip.split(')')
#   parent_node = 
#     if planets[parent].nil?
#       planets[parent] = Node.new(parent, nil, 0)
#       # binding.pry
#     else
#       planets[parent]
#     end
#   if planets[child].nil?
#     planets[child] = Node.new(child, parent, planets[parent].depth + 1)
#   end
# end

# binding.pry
com_node = Node.new('COM', nil, 0)
planets['COM'] = com_node
build_map(input, planets, com_node)

orbits = planets.reduce(0){ |sum, (name, node)| sum + node.depth }

puts orbits

you_parents = get_parents('YOU', planets)
san_parents = get_parents('SAN', planets)

you_parents.each_with_index do |x,i|
  index = san_parents.find_index(x)
  if index
    puts "found match: YOU #{i} SAN #{x} #{index}"
    break
  end
end

# 200001
# found match: YOU 191 SAN WYD 188

binding.pry
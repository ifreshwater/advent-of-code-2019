require 'pry'
require 'json'

DX = { L: -1, R: 1, U: 0, D: 0 }
DY = { L: 0, R: 0, U: 1, D: -1 }

def get_wire(dirs)
  x = 0
  y = 0
  length = 0
  path = {}
  dirs.each do |arg|
    dir = arg[0].to_sym
    amt = arg[1..-1].to_i
    (0..amt-1).each do |_|
      x += DX[dir]
      y += DY[dir]
      length += 1
      path["#{x},#{y}"] = length
    end
  end

  path
end
input = File.readlines('input')
wire1 = get_wire(input[0].strip.split(','))
wire2 = get_wire(input[1].strip.split(','))

overlap = wire1.keys & wire2.keys
overlap_dists = overlap.map{|x| x.split(',').map(&:to_i).reduce(&:+).abs }
overlap_steps = overlap.map{|x| wire1[x] + wire2[x] }

puts JSON.generate(overlap)
puts JSON.generate(overlap_dists)
puts JSON.generate(overlap_steps)
puts overlap_dists.min
puts overlap_steps.min
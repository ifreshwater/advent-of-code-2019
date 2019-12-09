require 'json'
require 'pry'

# input = "123456789012".chars.map(&:to_i)
# width, height = [3,2]
# input = "0222112222120000".chars.map(&:to_i)
# dimensions = [2,2]

input = File.readlines('input')
input = input[0].chars.map(&:to_i)
dimension=  [25, 6]

def generate_layers(input, dimensions)
  width, height = dimensions
  input.each_with_index.reduce([]) do |layers, (c, i)|
    layer_id = i/(height * width)
    row = (i/width) % height
    col = i % width
    layers[layer_id] ||= []
    layers[layer_id][row] ||= []
    layers[layer_id][row][col] = c
    layers
  end
end

def decode_image(layers, dimensions)
  width, height = dimensions
  final_image = []
  (0..height-1).each do |y|
    final_image[y] ||= []
    (0..width-1).each do |x|
      final_image[y][x] = layers.map { |layer| layer[y][x] }.find { |x| x < 2 }
    end
  end
  final_image
end
layers = generate_layers(input, dimensions)
# puts JSON.generate(generate_layers(input, dimensions))
puts JSON.generate(decode_image(layers, dimensions))



# min_zero = layers.min_by{|layer| layer.reduce(0) { |sum, row| sum + row.count(0) }}
# checksum = min_zero.reduce(0) { |sum, row| sum + row.count(1)} * min_zero.reduce(0) { |sum, row| sum + row.count(2)}
# puts checksum

# [
#   [ ,X,X, , ,X,X,X,X, ,X, , ,X, ,X, , ,X, , ,X,X, , ],
#   [X, , ,X, ,X, , , , ,X, ,X, , ,X, , ,X, ,X, , ,X, ],
#   [X, , , , ,X,X,X, , ,X,X, , , ,X, , ,X, ,X, , ,X, ],
#   [X, , , , ,X, , , , ,X, ,X, , ,X, , ,X, ,X,X,X,X, ],
#   [X, , ,X, ,X, , , , ,X, ,X, , ,X, , ,X, ,X, , ,X, ],
#   [ ,X,X, , ,X,X,X,X, ,X, , ,X, , ,X,X, , ,X, , ,X, ]
# ]
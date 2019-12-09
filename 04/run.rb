require 'pry'
start = 138241
stop = 674034

# start = 111121
# stop = 111123

def validPass?(n)
  double = false
  prev_char = nil
  groups = []
  curr_group = []
  n.to_s.chars.each do |c|
    # binding.pry
    if c != prev_char && prev_char != nil
      # binding.pry
      groups << curr_group
      curr_group = []
    end
    curr_group << c 

    return false if c.to_i < prev_char.to_i
    prev_char = c 
  end
  groups << curr_group
  group2 = groups.reduce(0) { |sum, curr| sum + (curr.length == 2 ? 1 : 0) }
  return group2 > 0
end

# puts validPass?(122345)
meets_criteria = (start..stop).reduce(0) do |sum, curr|
  sum + (validPass?(curr) ? 1 : 0)
end

puts meets_criteria
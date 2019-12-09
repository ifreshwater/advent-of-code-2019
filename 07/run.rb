require 'json'
require 'pry'

# input = File.readlines('input')
# input = input[0].split(',').map(&:to_i)

# input = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
# input = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
# input = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
# input = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]
input = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]

# binding.pry

class Amplifier
  def initialize(program)
    @program = program
  end
end



def value(n, mode, memory)
  # binding.pry
  mode == 1 ? n : memory[n]
end

def run_prog(prog, inputs = nil)
  last_printed = nil
  pointer = 0
  inputs_asked = 0
  while prog[pointer] != 99
    params_count = 1
    full_op = prog[pointer].to_s.rjust(5,'0')
    puts "operation: #{full_op}" 
    opcode = full_op[-2..-1].to_i
    arg1_mode = full_op[-3].to_i
    arg2_mode = full_op[-4].to_i
    arg3_mode = full_op[-5].to_i
    case opcode
    when 1 # add
      params_count = 4
      x = value(prog[pointer+1], arg1_mode, prog)
      y = value(prog[pointer+2], arg2_mode, prog)
      out_addr = prog[pointer+3]
      prog[out_addr] = x + y
      puts "changing addr #{out_addr} to #{x} + #{y}  = #{x+y}"
    when 2 # multiply
      params_count = 4
      x = value(prog[pointer+1], arg1_mode, prog)
      y = value(prog[pointer+2], arg2_mode, prog)
      out_addr = prog[pointer+3]
      prog[out_addr] = x * y
      puts "changing addr #{out_addr} to #{x} * #{y}  = #{x*y}"
    when 3 # gets
      
      params_count = 2
      addr = prog[pointer+1]
      puts 'getting input'
      if inputs
        text = inputs[inputs_asked]
        inputs_asked += 1
      else
        text  = gets
      end
      prog[addr] = text.to_i
    when 4 # puts
      params_count = 2
      last_printed = value(prog[pointer+1],arg1_mode,prog)
      puts last_printed
    when 5 # jump if true (arg1 != 0)
      arg1 = value(prog[pointer+1], arg1_mode, prog)
      arg2 = value(prog[pointer+2], arg2_mode, prog)
      test_result = !arg1.zero?
      if test_result
        pointer = arg2
        params_count = 0
      else
        params_count = 3
      end
    when 6 # jump if false (arg1 == 0)
      arg1 = value(prog[pointer+1], arg1_mode, prog)
      arg2 = value(prog[pointer+2], arg2_mode, prog)
      test_result = arg1.zero?
      if test_result
        pointer = arg2
        params_count = 0
      else
        params_count = 3
      end
    when 7 # less than (arg1 < arg2)
      arg1 = value(prog[pointer+1], arg1_mode, prog)
      arg2 = value(prog[pointer+2], arg2_mode, prog)
      arg3 = prog[pointer+3]
      prog[arg3] = (arg1 < arg2 ? 1 : 0)
      params_count = 4
    when 8 # equals (arg1 == arg2)
      arg1 = value(prog[pointer+1], arg1_mode, prog)
      arg2 = value(prog[pointer+2], arg2_mode, prog)
      arg3 = prog[pointer+3]
      prog[arg3] = (arg1 == arg2 ? 1 : 0)
      params_count = 4
    when 99
      break
    end
    pointer += params_count
  end
  # return prog[0]
  return last_printed
end

# input [1] = 12
# input [2] = 2
# puts run_prog(input)

# solution = 19690720
# (0..99).each do |noun|
#   catch :solution_found do
#     (0..99).each do |verb|
#       memory = input.clone
#       input[1] = noun
#       input[2] = verb

#       val = run_prog(memory)
      
#       if val == solution
#         puts JSON.generate(memory[0..3])
#         puts "noun #{noun} verb #{verb}"
#         puts 100 * noun + verb 
#         throw :solution_found
#       end      
#     end
#   end
# end

# phase_poss = [0,1,2,3,4].permutation(5).to_a
# phase_poss = [
#   # [4,3,2,1,0],
#   # [0,1,2,3,4]
#   # [1,0,4,3,2]
#]
phase_poss = [
  [9,8,7,5,6]
]

thrust = {}
phase_poss.each do |settings|
  memory = input.clone
  last_result = 0
  settings.each do |x|
    last_result = run_prog(memory, [x,last_result])
  end
  # binding.pry
  thrust[settings.join()] = last_result
end

puts JSON.generate(thrust)
max_thrust = thrust.max_by { |(key, value)| value }
puts JSON.generate(max_thrust)

# p1: ["20431",273814]
# p2: 
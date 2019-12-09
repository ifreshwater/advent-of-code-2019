require 'json'
require 'pry'
# input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,5,23,2,23,6,27,1,27,5,31,2,6,31,35,1,5,35,39,2,39,9,43,1,43,5,47,1,10,47,51,1,51,6,55,1,55,10,59,1,59,6,63,2,13,63,67,1,9,67,71,2,6,71,75,1,5,75,79,1,9,79,83,2,6,83,87,1,5,87,91,2,6,91,95,2,95,9,99,1,99,6,103,1,103,13,107,2,13,107,111,2,111,10,115,1,115,6,119,1,6,119,123,2,6,123,127,1,127,5,131,2,131,6,135,1,135,2,139,1,139,9,0,99,2,14,0,0]
# input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,6,19,23,2,23,6,27,1,5,27,31,1,31,9,35,2,10,35,39,1,5,39,43,2,43,10,47,1,47,6,51,2,51,6,55,2,55,13,59,2,6,59,63,1,63,5,67,1,6,67,71,2,71,9,75,1,6,75,79,2,13,79,83,1,9,83,87,1,87,13,91,2,91,10,95,1,6,95,99,1,99,13,103,1,13,103,107,2,107,10,111,1,9,111,115,1,115,10,119,1,5,119,123,1,6,123,127,1,10,127,131,1,2,131,135,1,135,10,0,99,2,14,0,0]

input = File.readlines('input')
input = input[0].split(',').map(&:to_i)
# input = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
# binding.pry
# input = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]


def value(n, mode, memory, relative_base)
  # binding.pry
  case mode
  when 0
    memory[n] || 0
  when 1
    n
  when 2
    memory[n + relative_base] || 0
  else
    raise "illegal mode"
  end
end

def addr(addr, mode, relative_base)
  return addr + relative_base if mode == 2
  addr
end

def run_prog(prog)
  debug = false
  pointer = 0
  relative_base = 0
  while prog[pointer] != 99
    params_count = 1
    full_op = prog[pointer].to_s.rjust(5,'0')
    puts "operation: #{full_op}" if debug
    opcode = full_op[-2..-1].to_i
    arg1_mode = full_op[-3].to_i
    arg2_mode = full_op[-4].to_i
    arg3_mode = full_op[-5].to_i
    case opcode
    when 1 # add
      params_count = 4
      x = value(prog[pointer+1], arg1_mode, prog, relative_base)
      y = value(prog[pointer+2], arg2_mode, prog, relative_base)
      out_addr = addr(prog[pointer+3], arg3_mode, relative_base)
      prog[out_addr] = x + y
      puts "changing addr #{out_addr} to #{x} + #{y}  = #{x+y}" if debug
    when 2 # multiply
      params_count = 4
      x = value(prog[pointer+1], arg1_mode, prog, relative_base)
      y = value(prog[pointer+2], arg2_mode, prog, relative_base)
      out_addr = addr(prog[pointer+3], arg3_mode, relative_base)
      prog[out_addr] = x * y
      puts "changing addr #{out_addr} to #{x} * #{y}  = #{x*y}" if debug
    when 3 # gets
      params_count = 2
      addr = 
        if arg1_mode == 2
          prog[pointer+1] + relative_base
        else
          prog[pointer+1]
        end
      puts 'getting input'
      text = gets
      prog[addr] = text.to_i
    when 4 # puts
      params_count = 2
      puts value(prog[pointer+1],arg1_mode,prog, relative_base)
    when 5 # jump if true (arg1 != 0)
      arg1 = value(prog[pointer+1], arg1_mode, prog, relative_base)
      arg2 = value(prog[pointer+2], arg2_mode, prog, relative_base)
      test_result = !arg1.zero?
      if test_result
        pointer = arg2
        params_count = 0
      else
        params_count = 3
      end
    when 6 # jump if false (arg1 == 0)
      arg1 = value(prog[pointer+1], arg1_mode, prog, relative_base)
      arg2 = value(prog[pointer+2], arg2_mode, prog, relative_base)
      test_result = arg1.zero?
      if test_result
        pointer = arg2
        params_count = 0
      else
        params_count = 3
      end
    when 7 # less than (arg1 < arg2)
      arg1 = value(prog[pointer+1], arg1_mode, prog, relative_base)
      arg2 = value(prog[pointer+2], arg2_mode, prog, relative_base)
      arg3 = addr(prog[pointer+3], arg3_mode, relative_base)
      prog[arg3] = (arg1 < arg2 ? 1 : 0)
      params_count = 4
    when 8 # equals (arg1 == arg2)
      arg1 = value(prog[pointer+1], arg1_mode, prog, relative_base)
      arg2 = value(prog[pointer+2], arg2_mode, prog, relative_base)
      arg3 = addr(prog[pointer+3], arg3_mode, relative_base)
      prog[arg3] = (arg1 == arg2 ? 1 : 0)
      params_count = 4
    when 9
      puts "relative_base change #{relative_base}" if debug
      arg1 = value(prog[pointer+1], arg1_mode, prog, relative_base)
      relative_base += arg1
      puts "relative_base now (+#{arg1}) #{relative_base}" if debug
      params_count = 2
    when 99
      break
    end
    pointer += params_count
  end
  # return prog[0]
end

run_prog(input)

# Part 1: (input 1) 3460311188
# Part 2: (input 2) 42202
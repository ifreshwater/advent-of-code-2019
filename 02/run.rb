require 'json'
# input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,5,23,2,23,6,27,1,27,5,31,2,6,31,35,1,5,35,39,2,39,9,43,1,43,5,47,1,10,47,51,1,51,6,55,1,55,10,59,1,59,6,63,2,13,63,67,1,9,67,71,2,6,71,75,1,5,75,79,1,9,79,83,2,6,83,87,1,5,87,91,2,6,91,95,2,95,9,99,1,99,6,103,1,103,13,107,2,13,107,111,2,111,10,115,1,115,6,119,1,6,119,123,2,6,123,127,1,127,5,131,2,131,6,135,1,135,2,139,1,139,9,0,99,2,14,0,0]
# input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,6,19,23,2,23,6,27,1,5,27,31,1,31,9,35,2,10,35,39,1,5,39,43,2,43,10,47,1,47,6,51,2,51,6,55,2,55,13,59,2,6,59,63,1,63,5,67,1,6,67,71,2,71,9,75,1,6,75,79,2,13,79,83,1,9,83,87,1,87,13,91,2,91,10,95,1,6,95,99,1,99,13,103,1,13,103,107,2,107,10,111,1,9,111,115,1,115,10,119,1,5,119,123,1,6,123,127,1,10,127,131,1,2,131,135,1,135,10,0,99,2,14,0,0]

def run_prog(prog)
  i = 0
  while prog[i] != 99
    op = prog[i]
    x_addr = prog[i+1]
    y_addr = prog[i+2]
    out_addr = prog[i+3]
    case prog[i]
    when 1
      prog[out_addr] = prog[x_addr] + prog[y_addr]
    when 2
      prog[out_addr] = prog[x_addr] * prog[y_addr]
    when 99
      break
    end
    i += 4
  end
  return prog[0]
end

# input [1] = 12
# input [2] = 2
# puts run_prog(input)

solution = 19690720
(0..99).each do |noun|
  catch :solution_found do
    (0..99).each do |verb|
      memory = input.clone
      input[1] = noun
      input[2] = verb

      val = run_prog(memory)
      
      if val == solution
        puts JSON.generate(memory[0..3])
        puts "noun #{noun} verb #{verb}"
        puts 100 * noun + verb 
        throw :solution_found
      end      
    end
  end
end

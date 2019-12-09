input = File.readlines('input')

def fuel_for(n)
  fuel = (n/3)-2
  return 0 unless fuel.positive?
  fuel + fuel_for(fuel)
end

fuel = input.inject(0) do |total, current|
  total + fuel_for(current.to_i)
end

puts fuel
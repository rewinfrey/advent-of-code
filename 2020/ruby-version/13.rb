require_relative "util"

def test_input
"939
7,13,x,x,59,x,31,19"
end

part 1 do
  input = test_input.split("\n")
  input = get_input(2020,13)
  target = input[0].to_i
  buses = input[1].gsub(/x,/,"").split(",").map(&:to_i)
  current = 0

  valid = true
  while valid
    if current >= target
      buses.each do |b|
        d = current / (b + 0.0)
        if (d - d.floor) == 0.0
          puts (current - target) * b
          valid = false
        end
      end
    end
    current += 1
  end
end

def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Multiplicative inverse modulo does not exist!'
  end
  x % et
end

# https://rosettacode.org/wiki/Chinese_remainder_theorem#Ruby
def chinese_remainder(mods, remainders)
  max = mods.inject( :* )  # product of all moduli
  series = remainders.zip(mods).map{ |r,m| (r * max * invmod(max/m, m) / m) }
  series.inject( :+ ) % max
end

def test_cases
  [
    ["\n17,x,13,19", 3417],
    ["\n67,7,59,61", 754018],
    ["\n67,x,7,59,61", 779210],
    ["\n67,7,x,59,61", 1261476],
    ["\n1789,37,47,1889", 1202161486],
  ]
end

def test_result(expected, actual)
  if expected != actual
    puts "expected: #{expected} but got #{actual}"
  else
    print "."
  end
end

part 2 do
  # input = test_input.split("\n")
  input = get_input(2020,13)
  buses = input[1].gsub(/x/, "0").split(",").map(&:to_i)
  both = [*1..buses.length].zip(buses).reject { |i, x| x == 0 }.map { |i, x| [x, -i % x] }
  mods = both.map(&:first)
  remainders = both.map(&:last)
  chinese_remainder(mods, remainders) + 1
end

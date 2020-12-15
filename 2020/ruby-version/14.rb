require_relative "util"

def dec2bin(number)
  number = Integer(number)
  if(number == 0) then 0 end

  ret_bin = ""
  while(number != 0)
      ret_bin = String(number % 2) + ret_bin
      number = number / 2
  end
  ret_bin
end

def bin2dec(binary)
  binary.reverse.chars.map.with_index do |digit, index|
    digit.to_i * 2**index
  end.sum
end

def test_input
"mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0".split("\n")
end

def indices(input, &block)
  input.each_with_index { |el,i| block.call(el, i) }
end

def apply_mask(mask, value)
  x = {
    zeroes: [],
    ones: [],
  }
  indices(mask) do |el, i|
    if el == "0" then x[:zeroes] << i end
    if el == "1" then x[:ones] << i end
  end
  v = value.split("")
  x[:zeroes].each do |i|
    v[i] = "0"
  end
  x[:ones].each do |i|
    v[i] = "1"
  end
  v.join
end

part 1 do
  mask = []
  # input = test_input
  input = get_input(2020,14)
  res = input.reduce({}) do |m, l|
    case
    when l.match?(/mask/)
      mask = l.split("=").map(&:strip).last.split("")
    when l.match?(/mem/)
      (k, v) = l.split("=").map(&:strip)
      b = dec2bin(v)
      padded_b = "0"*(36-b.length) + b
      m[k] = apply_mask(mask, padded_b)
    end
    m
  end

  total = res.values.reduce(0) { |s, v| s += bin2dec(v); s }

  total
end

def apply_mask_two(mask, value)
  permutations = []
  x = {
    xes: [],
    zeroes: [],
    ones: [],
  }
  indices(mask) do |el, i|
    if el == "0" then x[:zeroes] << i end
    if el == "1" then x[:ones] << i end
  end
  v = value.split("")
  x[:zeroes].each do |i|
    v[i] = "0"
  end
  x[:ones].each do |i|
    v[i] = "1"
  end
  x[:xes].each do |i|
    v[i] = "X"
  end

  x
end

def test_input_two
  "mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1".split("\n")
end

def apply_address_mask(mask, address)
  x = {
    xes: [],
    ones: [],
  }
  indices(mask) do |el, i|
    if el == "X" then x[:xes] << i end
    if el == "1" then x[:ones] << i end
  end
  address = address.split("")
  x[:ones].each do |i|
    address[i] = "1"
  end
  x[:xes].each do |i|
    address[i] = "X"
  end

  [address.join.gsub(/X/, "0"), x[:xes].reverse]
end

def permutate(input, indices, collection)
  indices.each.with_index do |el, i|
    next_input = input.clone
    next_input[el] = "1"
    collection << next_input
    permutate(next_input, indices[0...i], collection)
  end
  collection
end


part 2 do
  mask = []
  # input = test_input_two
  input = get_input(2020,14)
  res = input.reduce({}) do |m, l|
    case
    when l.match?(/mask/)
      mask = l.split("=").map(&:strip).last.split("")
    when l.match?(/mem/)
      (k, v) = l.split("=").map(&:strip)
      v_prime = v.gsub(/x/, "0")
      a = k.match(/\d+/).to_a.first
      b = dec2bin(a)
      padded_b = "0"*(36-b.length) + b
      (address, indices) = apply_address_mask(mask, padded_b)

      collection = [address]

      permutate(address, indices, collection).each do |a|
        m[bin2dec(a).to_s] = v.to_i
      end
    end
    m
  end

  total = res.values.reduce(0) { |s, v| s += v; s }

  total
end

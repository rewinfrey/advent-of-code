require_relative "util"

def preamble_length
  25
end

def input
  @input ||= get_input(2020,9).map(&:to_i)
end

def preamble
  input[0..preamble_length]
end

def find_invalid
  window = input[0..preamble_length]
  index = preamble_length + 1
  input[index..].each do |num|
    if !(window.combination(2).any? { |x, y| (x + y) == num })
      break num
    end
    index += 1
    window = input[index - (preamble_length) .. (index - 1)]
  end
end

part 1 do
  find_invalid
end

part 2 do
  target = find_invalid

  input.each_with_index do |num, index|
    window = [num]

    input[index + 1..].each do |n|
      window << n

      if window.sum == target
        puts window.sort.first + window.sort.last
        return
      end
    end
  end
end

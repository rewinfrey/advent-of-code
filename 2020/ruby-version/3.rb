require_relative "util"

def with_offsets(input, offsets, &block)
  offsets.map do |offset|
    map = { row: 0, col: 0, count: 0, }

    while map[:row] < input.length
      map[:count] += 1 if block.call(input[map[:row]][map[:col]])
      map[:row] = map[:row] + offset[:d]
      map[:col] = (map[:col] + offset[:r]) % input.first.length
    end

    map
  end
end

part 1 do
  with_offsets(get_input(2020, 3), [{r: 3, d: 1}]) do |space|
    space == "#"
  end.first[:count]
end

part 2 do
  offsets = [
    {r: 1, d: 1},
    {r: 3, d: 1},
    {r: 5, d: 1},
    {r: 7, d: 1},
    {r: 1, d: 2},
  ]

  with_offsets(get_input(2020, 3), offsets) do |space|
    space == "#"
  end.inject(1) { |s, r| s * r[:count] }
end

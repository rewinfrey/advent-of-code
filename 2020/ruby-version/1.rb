require_relative "util"

def with_combination(input, index, limit, combo, &block)
  input[index..].each_with_index do |el, i|
    combo.push(el)
    if combo.length == limit
      if result = block.call(combo) then return result end
    else
      with_combination(input, i + 1, limit, combo, &block)
    end
    combo.pop
  end
  nil
end

part 1 do
  with_combination(get_input(2020, 1), 0, 2, []) do |vals|
    vals.map(&:to_i).inject(&:+) == 2020 && vals.map(&:to_i).inject(&:*)
  end
end

part 2 do
  with_combination(get_input(2020, 1), 0, 3, []) do |vals|
    vals.map(&:to_i).inject(&:+) == 2020 && vals.map(&:to_i).inject(&:*)
  end
end

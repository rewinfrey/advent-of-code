require_relative "util"

def next_surrounding_state(input, cur_state, row_index, col_index)
  surrounding = []
  surrounding << input[row_index-1][col_index-1] unless row_index == 0 || col_index == 0
  surrounding << input[row_index-1][col_index] unless row_index == 0
  surrounding << input[row_index-1][col_index+1] unless row_index == 0 || col_index == input.first.length - 1

  surrounding << input[row_index][col_index-1] unless col_index == 0
  surrounding << input[row_index][col_index+1] unless col_index == input.first.length - 1

  surrounding << input[row_index+1][col_index-1] unless row_index == input.length - 1 || col_index == 0
  surrounding << input[row_index+1][col_index] unless row_index == input.length - 1
  surrounding << input[row_index+1][col_index+1] unless row_index == input.length - 1 || col_index == input.first.length - 1

  case cur_state
  when "L"
    return "#" if !surrounding.any? { |s| s == "#" }
    return "L"
  when "#"
    return "L" if surrounding.reduce(0) { |sum, s| sum += 1 if s == "#"; sum } >= 4
    return "#"
  else
    return "."
  end
end

def iterate(input, &block)
  row_index = -1
  next_input = input.map do |row|
    row_index += 1
    col_index = -1
    row.map do |seat|
      col_index += 1
      block.call(input, seat, row_index, col_index)
    end
  end

  if next_input == input
    return input
  else
    iterate(next_input, &block)
  end
end

def seat_count(input, target)
  input.map do |row|
    row.reduce(0) { |sum, s| sum += 1 if s == target; sum }
  end.sum
end

part 1 do
  input = get_input(2020, 11).map { |row| row.split("") }
  stable = iterate(input) { |input, seat, row_index, col_index| next_surrounding_state(input, seat, row_index, col_index) }
  seat_count(stable, "#")
end

def next_visible(input, position, &block)
  next_row, next_col = position

  while true
    next_row, next_col = block.call(next_row, next_col)
    if next_row < 0 || next_col < 0 || next_row == input.length || next_col == input.first.length
      return "."
    else
      case input[next_row][next_col]
      when "#" then return "#"
      when "L" then return "L"
      end
    end
  end
end

def next_visible_state(input, cur_state, row_index, col_index)
  visible = []

  visible << next_visible(input, [row_index, col_index]) { |row, col| [row - 1, col - 1] }
  visible << next_visible(input, [row_index, col_index]) { |row, col| [row - 1, col] }
  visible << next_visible(input, [row_index, col_index]) { |row, col| [row - 1, col + 1] }

  visible << next_visible(input, [row_index, col_index]) { |row, col| [row, col - 1] }
  visible << next_visible(input, [row_index, col_index]) { |row, col| [row, col + 1] }

  visible << next_visible(input, [row_index, col_index]) { |row, col| [row + 1, col - 1] }
  visible << next_visible(input, [row_index, col_index]) { |row, col| [row + 1, col] }
  visible << next_visible(input, [row_index, col_index]) { |row, col| [row + 1, col + 1] }

  case cur_state
  when "L"
    return "#" if !visible.any? { |s| s == "#" }
    return "L"
  when "#"
    return "L" if visible.reduce(0) { |sum, s| sum += 1 if s == "#"; sum } >= 5
    return "#"
  else
    return "."
  end
end

part 2 do
  input = get_input(2020, 11).map { |row| row.split("") }
  stable = iterate(input) { |input, seat, row_index, col_index| next_visible_state(input, seat, row_index, col_index) }
  seat_count(stable, "#")
end

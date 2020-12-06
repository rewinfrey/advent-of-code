require_relative "util"

part 1 do
  get_input(2020,5).map do |line|
    row = line[0..6].split("").inject({r_lower:0, r_upper:127}) do |row_search, instruction|
      case instruction
      when "B" then row_search[:r_lower] = row_search[:r_upper] - ((row_search[:r_upper] - row_search[:r_lower]) / 2)
      when "F" then row_search[:r_upper] = row_search[:r_lower] + ((row_search[:r_upper] - row_search[:r_lower]) / 2)
      end
      row_search
    end

    col = line[7..].split("").inject({c_lower:0, c_upper:7}) do |col_search, instruction|
      case instruction
      when "R" then col_search[:c_lower] = col_search[:c_upper] - ((col_search[:c_upper] - col_search[:c_lower]) / 2)
      when "L" then col_search[:c_upper] = col_search[:c_lower] + ((col_search[:c_upper] - col_search[:c_lower]) / 2)
      end
      col_search
    end

    row.merge(col)
  end.map do |row_col|
    row_col[:r_lower] * 8 + row_col[:c_lower]
  end.sort.reverse.first
end

part 2 do
  blank_seats = Array.new(128) { Array.new(8) {nil} }
  get_input(2020,5).each do |line|
    row = line[0..6].split("").inject({r_lower:0, r_upper:127}) do |row_search, instruction|
      case instruction
      when "B" then row_search[:r_lower] = row_search[:r_upper] - ((row_search[:r_upper] - row_search[:r_lower]) / 2)
      when "F" then row_search[:r_upper] = row_search[:r_lower] + ((row_search[:r_upper] - row_search[:r_lower]) / 2)
      end
      row_search
    end

    col = line[7..].split("").inject({c_lower:0, c_upper:7}) do |col_search, instruction|
      case instruction
      when "R" then col_search[:c_lower] = col_search[:c_upper] - ((col_search[:c_upper] - col_search[:c_lower]) / 2)
      when "L" then col_search[:c_upper] = col_search[:c_lower] + ((col_search[:c_upper] - col_search[:c_lower]) / 2)
      end
      col_search
    end

    blank_seats[row[:r_lower]][col[:c_lower]] = true
  end

  possible_seats = []
  blank_seats.each_with_index do |row, r_index|
    row.each_with_index do |col, c_index|
      possible_seats << {row: r_index, col: c_index} unless col
    end
  end
  possible_seats.map do |seat|
    seat[:row] * 8 + seat[:col]
  end
end

require_relative "util"

def test_input
"z=0
.#.
..#
###".split("\n")
end

def next_state(last, h, pos)
  iter = [-1, 0, 1]
  active = 0
  inactive = 0
  iter.each do |x|
    iter.each do |y|
      iter.each do |z|
        (px, py, pz) = pos
        next_pos = [px + x, py + y, pz + z]
        next if pos == next_pos
        if last[next_pos] == '.' #|| last[next_pos].nil?
          inactive += 1
        elsif last[next_pos] == '#'
          active += 1
        end
      end
    end
  end

  # if pos == [2,2,0]
  #   require 'pry'
  #   binding.pry
  # end

  case last[pos]
  when '.' then h[pos] = active == 3 ? '#' : '.'
  when '#' then h[pos] = active == 3 || active == 2 ? '#' : '.'
  else
    puts "here"
  end
  h
end

part 1 do
  z = 0
  y = 0
  w = 0
  last = test_input[1..].reduce({}) do |h, row|
    row.split("").map.with_index do |cell, x|
      h[[x.to_i, y.to_i, z.to_i]] = cell
    end
    y += 1
    h
  end

  # y = 0
  # input = get_input(2020,17)
  # last = input.reduce({}) do |h, row|
  #   row.split("").map.with_index do |cell, x|
  #     h[[x.to_i, y.to_i, z.to_i]] = cell
  #   end
  #   y += 1
  #   h
  # end

  iter = [-1, 0, 1]
  6.times do |_|
    next_positions = last.keys.reduce({}) do |h, pos|
      iter.each do |x|
        iter.each do |y|
          iter.each do |z|
            (px, py, pz) = pos
            next_pos = [px + x, py + y, pz + z]
            if h[next_pos].nil?
              h[next_pos] = '.'
            else
              h[next_pos] = last[next_pos] || '.'
            end
            h
          end
          h
        end
        h
      end
      h
    end

    last = next_positions.keys.reduce({}) do |h, pos|
      h[pos] = next_positions[pos]
      next_state(next_positions, h, pos)
      h
    end
  end
  puts last.values.inject(0) { |s, v| s += 1 if v == '#'; s }
end

def next_state2(last, h, pos)
  iter = [-1, 0, 1]
  active = 0
  inactive = 0
  iter.each do |x|
    iter.each do |y|
      iter.each do |z|
        iter.each do |w|
          (px, py, pz, pw) = pos
          next_pos = [px + x, py + y, pz + z, pw + w]
          next if pos == next_pos
          if last[next_pos] == '.' #|| last[next_pos].nil?
            inactive += 1
          elsif last[next_pos] == '#'
            active += 1
          end
        end
      end
    end
  end

  case last[pos]
  when '.' then h[pos] = active == 3 ? '#' : '.'
  when '#' then h[pos] = active == 3 || active == 2 ? '#' : '.'
  else
    puts "here"
  end
  h
end

part 2 do
  # z = 0
  # y = 0
  # w = 0

  # input = get_input(2020,17)
  # last = input.reduce({}) do |h, row|
  #   row.split("").map.with_index do |cell, x|
  #     h[[x.to_i, y.to_i, z.to_i, w.to_i]] = cell
  #   end
  #   y += 1
  #   h
  # end

  z = 0
  y = 0
  w = 0
  last = test_input[1..].reduce({}) do |h, row|
    row.split("").map.with_index do |cell, x|
      h[[x.to_i, y.to_i, z.to_i, w.to_i]] = cell
    end
    y += 1
    h
  end

  iter = [-1, 0, 1]
  6.times do |_|
    next_positions = last.keys.reduce({}) do |h, pos|
      iter.each do |x|
        iter.each do |y|
          iter.each do |z|
            iter.each do |w|
              (px, py, pz, pw) = pos
              next_pos = [px + x, py + y, pz + z, pw + w]
              if h[next_pos].nil?
                h[next_pos] = '.'
              else
                h[next_pos] = last[next_pos] || '.'
              end
              h
            end
            h
          end
          h
        end
        h
      end
      h
    end

    last = next_positions.keys.reduce({}) do |h, pos|
      h[pos] = next_positions[pos]
      next_state2(next_positions, h, pos)
      h
    end
  end
  puts last.values.inject(0) { |s, v| s += 1 if v == '#'; s }
end

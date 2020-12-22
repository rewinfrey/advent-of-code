require_relative "util"

def test_input
"Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
".split("\n\n")
end

class Tile
  attr_accessor :name, :rows, :neighbors, :top, :right, :bottom, :left

  def initialize(s)
    parse_raw(s)
    @sides = nil
    @neighbors = Set.new
  end

  def add_neighbor(tile)
    @neighbors << tile
  end

  def rotate(n = 1)
    new_rows = Array.new(rows.first.split("").length) { Array.new }
    rows.each do |row|
      row.split("").each.with_index do |c, i|
        new_rows[i].unshift(c.clone)
      end
    end
    @rows = new_rows.map { |row| row.join }
  end

  def hflip(n = 1)
    @rows = rows.map { |row| row.clone.reverse }
  end

  def vflip(n = 1)
    new_rows = Array.new(rows.length) { Array.new(rows.first.length) }
    rows.length.times do |y|
      new_col = rows.map { |r| r[y] }.reverse
      new_col.each.with_index do |e, x|
        new_rows[x][y] = e
      end
    end
    @rows = new_rows.map { |row| row.join }
  end

  def sides
    one = rows.first
    two = rows.map { |row| row[-1] }.join
    three = rows.last
    four = rows.map { |row| row[0] }.join
    @sides = [one, two, three, four]
  end

  def show
    print rows.join("\n")
  end

  def borderless_rows
    rows[1...-1].map do |row|
      row[1...-1]
    end
  end

  def monster
"                  #
#    ##    ##    ###
 #  #  #  #  #  #   ".split("\n").map { |row| row.split("") }
  end

  def monster_indices
    monster.map do |row|
      row.map.with_index { |el, i| i if el == '#' }.compact
    end
  end

  def find_monster
    monster_length = 19
    has_monster = false
    [*0..2].each do |rotate_number|
      return true if has_monster
      [*0..2].each do |flip_number|
        return true if has_monster
        row_offset = 0
        while row_offset <= rows.length - monster_indices.length
          col_offset = 0
          while col_offset <= rows.first.length - monster_length
            found = monster_indices.each.with_index.all? do |monster_row, monster_row_offset|
              monster_row.all? do |monster_col_offset|
                rows[row_offset + monster_row_offset][col_offset + monster_col_offset] == '#'
              end
            end

            if found
              has_monster = true
              monster_indices.each.with_index do |monster_row, monster_row_offset|
                monster_row.each do |monster_col_offset|
                  rows[row_offset + monster_row_offset][col_offset + monster_col_offset] = 'O'
                end
              end
            end

            col_offset += 1
          end
          row_offset += 1
        end
        return true if has_monster
        case flip_number
        when 0
          hflip
        when 1
          hflip
          vflip
        when 2
          vflip
        end
      end
      rotate
    end
    has_monster
  end

  private

  def parse_raw(s)
    parts = s.split("\n")
    @name = parts[0].gsub(/:/,"").split(" ").last.to_i
    @rows = parts[1..]
  end
end

class Map
  attr_accessor :tiles, :map, :rows

  def initialize
    @tiles = Set.new
    @map = {}
  end

  def add_tile(tile)
    @tiles << tile
    @map[tile.name] = {
      tile: tile
    }
  end

  def corners
    @tiles.filter { |t| t.neighbors.count == 2 }
  end

  def compute_neighbors
    @tiles.each do |t1|
      @tiles.each do |t2|
        match(t1, t2)
      end
    end
  end

  def match(t1, t2)
    return if t1.name == t2.name
    t1.sides.each.with_index do |t1_side, t1_i|
      t2.sides.each.with_index do |t2_side, t2_i|
        if t1_side == t2_side || t1_side == t2_side.reverse
          t1.add_neighbor(t2)
        end
      end
    end
  end

  # Map is always square.
  def size
    Math.sqrt(tiles.length)
  end

  def stitch_rows
    @rows ||= Array.new( size ) { Array.new }

    @rows.each.with_index do |next_row, next_index|
      if next_index == 0
        next_row << orient_row_anchor(corners.first, true)
      elsif next_index == @rows.length - 1
        # This isn't correct!
        # This tile needs to be rotated to match the bottom of the previous row's tile!
        next_tile = @rows[next_index - 1].first.bottom
        next_row << next_tile
      else
        next_row << orient_row_anchor(@rows[next_index - 1].first.bottom, false)
      end

      stitch_neighbors(next_row)
    end
  end

  def next_right(tile)
    return tile.right if tile.right
    (_, right_side, _, _) = tile.sides
    tile.neighbors.select { |n| n.top.nil? && n.right.nil? && n.bottom.nil? && n.left.nil? }.each do |neighbor|
      [*1..4].each do
        (_, _, _, left_side) = neighbor.sides

        if right_side == left_side || right_side == left_side.reverse
          neighbor.vflip if right_side == left_side.reverse
          tile.right = neighbor
          neighbor.left = tile
        else
          neighbor.rotate
        end
      end
    end
  end

  def stitch_neighbors(row)
    searching = true
    while searching
      tile = row.last
      next_right(tile)
      if tile.right
        row << tile.right
      else
        searching = false
      end
    end
  end

  def orient_row_anchor(tile, with_rotation)
    rotations = with_rotation ? [*1..4] : [1]
    rotations.each do |_|
      (_, right_side, bottom_side, _) = tile.sides
      tile.neighbors.select { |neighbor| neighbor.left.nil? }.each do |neighbor|
        break if tile.right
        [*1..4].each do
          (_, _, _, neighbor_left) = neighbor.sides

          if right_side == neighbor_left || right_side == neighbor_left.reverse
            neighbor.vflip if right_side == neighbor_left.reverse
            tile.right = neighbor
            neighbor.left = tile
            break
          else
            neighbor.rotate
          end
        end
      end

      tile.neighbors.select { |neighbor| neighbor.top.nil? }.each do |neighbor|
        break if tile.bottom
        [*1..4].each do
          (neighbor_top, _, _, _) = neighbor.sides

          if bottom_side == neighbor_top || bottom_side == neighbor_top.reverse
            neighbor.hflip if bottom_side == neighbor_top.reverse
            tile.bottom = neighbor
            neighbor.top = tile
            break
          else
            neighbor.rotate
          end
        end
      end

      break if tile.right && tile.bottom
      tile.right.left = nil if tile.right && tile.right.left
      tile.right = nil
      tile.bottom.top = nil if tile.bottom && tile.bottom.top
      tile.bottom = nil
      tile.rotate
    end

    tile
  end

  def blank_position
    [nil, nil]
  end

  def debug_show
    out = ""
    rows.each do |row|
      [*0..row.first.rows.length - 1].each do |row_index|
        row.each do |tile|
          out << tile.rows[row_index] << " "
        end
        out << "\n"
      end
      out << "\n"
    end
    print out
  end

  def debug_borderless_show
    out = ""
    rows.each do |row|
      [*0..row.first.borderless_rows.length - 1].each do |row_index|
        row.each do |tile|
          out << tile.borderless_rows[row_index] << " "
        end
        out << "\n"
      end
      out << "\n"
    end
    print out
  end

  def show
    out = "Tile 1:\n"
    rows.each do |row|
      [*0..row.first.borderless_rows.length - 1].each do |row_index|
        row.each do |tile|
          out << tile.borderless_rows[row_index]
        end
        out << "\n"
      end
    end
    out
  end
end

part 1 do
  input = test_input
  map = Map.new
  input.each { |raw_tile| map.add_tile(Tile.new(raw_tile)) }
  map.compute_neighbors
  map.corners.inject(1) { |s, t| s *= t.name }
end

part 2 do
  input = test_input
  input = get_raw(2020,20).split("\n\n")
  map = Map.new
  input.each { |raw_tile| map.add_tile(Tile.new(raw_tile)) }
  map.compute_neighbors
  map.stitch_rows
  map.debug_show
  map.debug_borderless_show
  full = map.show
  full_tile = Tile.new(full)
  full_tile.find_monster
  full_tile.rows.map { |r| r.split("").count { |el| el == '#' } }.sum
end

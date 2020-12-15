require_relative "util"

def test_input
"F10
N3
F7
R90
F11".split("\n")
end

def degrees
  {
    "N" => 90,
    "E" => 0,
    "S" => 270,
    "W" => 180,
  }
end

def manhanttan_position(ship)
  ship[:position].first.abs + ship[:position].last.abs
end

def update(ship, i)
  current = ship[:facing]
  x = ship[:position][0]
  y = ship[:position][1]
  d = i[0]
  m = i[1..].join.to_i

  case d
    when "N" then ship[:position] = [x, y + m]
    when "E" then ship[:position] = [x + m, y]
    when "S" then ship[:position] = [x, y - m]
    when "W" then ship[:position] = [x - m, y]
    when "L"
      ship[:facing] = degrees.invert[(degrees[current] + m) % 360]
    when "R"
      ship[:facing] = degrees.invert[(degrees[current] + (360 - m)) % 360]
    when "F"
      case ship[:facing]
      when "N" then ship[:position] = [x, y + m]
      when "E" then ship[:position] = [x + m, y]
      when "S" then ship[:position] = [x, y - m]
      when "W" then ship[:position] = [x - m, y]
      else
        puts ship[:facing]
        puts "impossible 1"
      end
    else
      puts d
     puts "impossible 2"
  end
end

part 1 do
  ship = {
    facing: "E",
    position: [0,0]
  }
  # test_input.map { |i| i.split("") }.each do |i|
  get_input(2020, 12).map { |i| i.split("") }.each do |i|
    update(ship, i)
  end

  puts manhanttan_position(ship)
  ship
end

def rotate_waypoint(dir, deg, wp_x, wp_y)
  wp_x_next = wp_x
  wp_y_next = wp_y
  rotations = deg / 90
  case dir
  when "L"
    rotations.times do |_|
      x_deg = wp_x_next >= 0 ? 0  : 180
      y_deg = wp_y_next >= 0 ? 90 : 270
      cur_x = wp_x_next
      cur_y = wp_y_next
      wp_x_next = ((y_deg + 90) % 360) > 90 ? -(cur_y.abs) : cur_y.abs
      wp_y_next = ((x_deg + 90) % 360) > 90 ? -(cur_x.abs) : cur_x.abs
    end
  when "R"
    rotations.times do |_|
      x_deg = wp_x_next >= 0 ? 360 : 180
      y_deg = wp_y_next >= 0 ? 90  : 270
      cur_x = wp_x_next
      cur_y = wp_y_next
      wp_x_next = ((y_deg - 90) % 360) > 90 ? -(cur_y.abs) : cur_y.abs
      wp_y_next = ((x_deg - 90) % 360) > 90 ? -(cur_x.abs) : cur_x.abs
    end
  end

  [wp_x_next, wp_y_next]
end

def update_two(ship, i)
  current = ship[:facing]
  ship_x = ship[:position][0]
  ship_y = ship[:position][1]
  wp_x   = ship[:waypoint][0]
  wp_y   = ship[:waypoint][1]
  d = i[0]
  m = i[1..].join.to_i

  case d
    when "N" then ship[:waypoint] = [wp_x, wp_y + m]
    when "E" then ship[:waypoint] = [wp_x + m, wp_y]
    when "S" then ship[:waypoint] = [wp_x, wp_y - m]
    when "W" then ship[:waypoint] = [wp_x - m, wp_y]
    when "L" then ship[:waypoint] = rotate_waypoint(d, m, wp_x, wp_y)
    when "R" then ship[:waypoint] = rotate_waypoint(d, m, wp_x, wp_y)
    when "F" then ship[:position] = [ship_x + (wp_x * m), ship_y + (wp_y * m)]
    else
      puts d
      puts "impossible 2"
  end
end

def ex
"R270
R90".split("\n")
end

def test_cases
[
  ["L90\n", {position: [0,0], waypoint: [-1, 10]}],
  ["R90\n", {position: [0,0], waypoint: [1, -10]}],
  ["R90\nF10\n", {position: [10,-100], waypoint: [1, -10]}],
  ["R90\nF10\nN3\n", {position: [10,-100], waypoint: [1, -7]}],
  ["R90\nF10\nS3\n", {position: [10,-100], waypoint: [1, -13]}],
  ["R90\nF10\nS3\nE3\n", {position: [10,-100], waypoint: [4, -13]}],
  ["R90\nF10\nS3\nE3\nF10\n", {position: [50,-230], waypoint: [4, -13]}],
  ["R90\nF10\nS3\nE3\nF10\nW3\n", {position: [50,-230], waypoint: [1, -13]}],
  ["R90\nF10\nS3\nE3\nF10\nW3\nN3\n", {position: [50,-230], waypoint: [1, -10]}],
  ["R90\nF10\nS3\nE3\nF10\nW3\nN3\nL90\n", {position: [50,-230], waypoint: [10, 1]}],
  ["R90\nF10\nS3\nE3\nF10\nW3\nN3\nL90\nL180\n", {position: [50,-230], waypoint: [-10, -1]}],

  ["R90\nR90\n", {position: [0,0], waypoint: [-10, -1]}],
  ["R90\nR90\nR90\n", {position: [0,0], waypoint: [-1, 10]}],
  ["R90\nR90\nR90\nR90", {position: [0,0], waypoint: [10,1]}],
  ["R180\n", {position: [0,0], waypoint: [-10,-1]}],
  ["R180\nR180\n", {position: [0,0], waypoint: [10,1]}],
  ["R180\nR90\n", {position: [0,0], waypoint: [-1, 10]}],
  ["R270\n", {position: [0,0], waypoint: [-1, 10]}],
  ["R270\nR180\n", {position: [0,0], waypoint: [1, -10]}],
  ["R270\nR180\nR90", {position: [0,0], waypoint: [-10, -1]}],
]
end

part 2 do
  ship = {
    position: [0,0],
    waypoint: [10,1],
  }

  get_input(2020, 12).map { |i| i.split("") }.each do |i|
    update_two(ship, i)
  end
  puts manhanttan_position(ship)
  ship

  # test_cases.each do |test_case|
  #   ship = {
  #     position: [0,0],
  #     waypoint: [10,1],
  #   }

  #   test_case[0].split("\n").map { |i| i.split("") }.each { |i| update_two(ship, i) }

  #   if test_case[1] == ship
  #     print "."
  #   else
  #     puts "fail"
  #     puts "expected: #{test_case[1]} but got: #{ship}"
  #   end
  # end

  # puts
end

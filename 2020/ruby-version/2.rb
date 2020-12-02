require_relative "util"

part 1 do
  get_input(2020, 2).filter do |line|
    parsed = line.split
    range = parsed[0].split("-").inject { |s, e| (s.to_i)..(e.to_i) }
    character = parsed[1].split(":").first
    password = parsed.last
    range.member?(password.count(character))
  end.length
end

part 2 do
  get_input(2020, 2).filter do |line|
    parsed = line.split
    range = parsed[0].split("-").map(&:to_i)
    character = parsed[1].split(":").first
    password = parsed.last
    (password[range[0] - 1] == character) ^ (password[range[1] - 1] == character)
  end.length
end

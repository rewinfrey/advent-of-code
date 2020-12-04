require_relative "util"

part 1 do
  required = [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
  ]

  get_raw(2020,4).split("\n\n").filter do |line|
    line.split(" ").length == 8 ||
      required.filter { |req| line.include?(req) }.length == 7
  end.length
end

part 2 do
  required =  {
    "byr" => -> (f) { /\d{4}$/.match?(f) && f.to_i >= 1920 && f.to_i <= 2002 },
    "iyr" => -> (f) { /\d{4}$/.match?(f) && f.to_i >= 2010 && f.to_i <= 2020 },
    "eyr" => -> (f) { /\d{4}$/.match?(f) && f.to_i >= 2020 && f.to_i <= 2030 },
    "hgt" => -> (f) {
        if f.include?("cm")
          h = f.split("cm").first.to_i
          h >= 150 && h <= 193
        elsif f.include?("in")
          h = f.split("in").first.to_i
          h >= 59 && h <= 76
        end
    },
    "hcl" => -> (f) { /^#[0-9a-f]{6}$/.match?(f) },
    "ecl" => -> (f) { %w(amb blu brn gry grn hzl oth).include?(f) },
    "pid" => -> (f) { /^[0-9]{9}$/.match?(f) },
  }

  get_raw(2020,4).split("\n\n").filter do |line|
    line.split(" ").length >= 7 &&
      required.all? do |f, l|
        if line.include?(f)
          l.call(line[line.index(f)..].split(" ").first.split(":").last)
        end
      end
  end.length
end

require 'httparty'

def part(n)
  puts "part #{n}"
  puts yield
end

def read(filename)
  File.read(filename).split("\n")
end

def get_input(year, day)
  HTTParty.get("https://adventofcode.com/#{year}/day/#{day}/input", {
    headers: {
      cookie: "session=#{ENV["SESSION"]}"
    }
  }).body.split("\n")
end

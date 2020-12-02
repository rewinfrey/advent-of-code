def part(n)
  puts "part #{n}"
  puts yield
end

def read(filename)
  File.read(filename).split("\n")
end

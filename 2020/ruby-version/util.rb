def part(n)
  puts "part #{n}"
  puts yield
end

def get_input(filename)
  File.read(filename).split("\n")
end

require_relative "util"

def test_input
"0,3,6"
end

def input
"1,2,16,19,18,0"
end

def initialize(input)
  turns = 1
  input.split(",").map(&:to_i).reduce({}) do |h, n|
    h[:last_spoken] = n
    h[n] ||= { turns: [] }
    h[n][:turns] << turns
    turns += 1
    h
  end
end

def play(tracker, limit)
  [*(tracker.keys.length)..limit].each do |turn|
    last_spoken = tracker[:last_spoken]
    turns = tracker[last_spoken][:turns]

    if turns.length == 1
      tracker[:last_spoken] = 0
      tracker[0] ||= { turns: [] }
      tracker[0][:turns] << turn
    else
      age = turns[-1] - turns[-2]
      tracker[:last_spoken] = age
      tracker[age] ||= { turns: [] }
      tracker[age][:turns] << turn
    end
  end
  tracker
end

part 1 do
  play(initialize(input), 2020)[:last_spoken]
end

part 2 do
  play(initialize(input), 30000000)[:last_spoken]
end

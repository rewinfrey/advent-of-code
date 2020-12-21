require_relative "util"

def test_input
'0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: a
5: b'.split("\n")
end

def complete_matches
"ababbb
abbbab".split("\n")
end

def incomplete_matches
"bababa
aaabbb
aaaabbb".split("\n")
end

def find_possible_matches(rules, limit)
  queue = rules["0"].map { |r| { rule: r.map(&:clone), match: "", depth: 0 } }
  matches = []

  count = 0
  while queue.any?
    count += 1
    puts "iteration: #{count}, matches: #{matches.length}, queue size: #{queue.length}"
    # Get first element off the queue.
    h = queue.shift
    sequence = h[:rule]
    match = h[:match]
    depth = h[:depth]

    current_rule = sequence.shift
    next_rules = rules[current_rule].map { |r| { rule: r.map(&:clone), match: match.clone, depth: depth } }

    require 'pry'
    binding.pry

    if sequence.include?(current_rule)
      depth += 1
      if depth > limit
        require 'pry'
        binding.pry
        sequence = sequence.filter { |el| el == current_rule }
      end
    end

    case next_rules.first[:rule]
    when ["\"a\""]
      match << "a"
      if sequence.any?
        queue.unshift({ rule: sequence, match: match, depth: depth })
      else
        matches << match
        match = ""
      end
    when ["\"b\""]
      match << "b"
      if sequence.any?
        queue.unshift({ rule: sequence, match: match, depth: depth })
      else
        matches << match
        match = ""
      end
    else
      require 'pry'
      binding.pry
      next_rules.reverse.map do |next_rule|
        queue.unshift({ rule: next_rule[:rule].push(sequence).flatten, match: next_rule[:match], depth: depth })
      end
    end
  end

  matches
end

# part 1 do
#   rules = get_raw(2020,19).split("\n\n").first.split("\n")
#   to_match = get_raw(2020,19).split("\n\n").last.split("\n")
#   parsed_rules = rules.reduce({}) do |h, l|
#     parts = l.split(":")
#     h[parts.first] ||= parts.last.split("|").map { |choice| choice.split(" ") }
#     h
#   end
#   matches = find_possible_matches(parsed_rules, -1)
#   to_match.inject(0) { |s, m| s += 1 if matches.include?(m); s }
# end

# part 2 do
#   rules = get_raw(2020,19).split("\n\n").first
#   rules.gsub!(/8\:\s42/, "8: 42 | 42 8")
#   rules.gsub!(/11\:\s42\s31/, "11: 42 31 | 42 11 31")
#   rules = rules.split("\n")

#   to_match = get_raw(2020,19).split("\n\n").last.split("\n")
#   limit = to_match.reduce(0) { |max, el| max = el.length if el.length > max; max }

#   parsed_rules = rules.reduce({}) do |h, l|
#     parts = l.split(":")
#     h[parts.first] ||= parts.last.split("|").map { |choice| choice.split(" ") }
#     h
#   end
#   matches = find_possible_matches(parsed_rules, 1)
#   to_match.inject(0) { |s, m| s += 1 if matches.include?(m); s }
# end

# alternative
part 2 do
  unparsed_rules, messages = get_raw(2020, 19).split("\n\n").map { |part| part.split("\n") }

  rules = {}

  unparsed_rules.each do |line|
    idx, rule = line.split /: /
    rules[idx] = rule
  end

  rules['8'] = "42+"
  rules['11'] = "(?<e>42 \\g<e>* 31)+"

  re = "^#{rules['0']}$"
  while true
    nums = re.scan /\d+/
    break if nums.length.zero?
    nums.each { |num| re.gsub!(/\b#{num}\b/, "(#{rules[num]})") }
  end

  re.gsub! /[" ]/, ''
  puts messages.count { |message| message.match? /#{re}/ }
end

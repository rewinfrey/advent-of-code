require_relative "util"

def test_input
"class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12".split("\n\n")
end

def test_input2
"class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9".split("\n\n")
end

def parse_ticket(input)
end

def error_rate(input, rules, rate)
  input[2].split("\n")[1..].each do |ticket|
    ti = ticket.split(",").map(&:to_i)
    ti.each do |v|
      if !rules.any? { |rule| rule[:ranges].any? { |r| r.include?(v) } }
        rate += v
      end
    end
  end

  rate
end

def error_filter(input, rules)
  index = 1
  input[2].split("\n")[1..].reduce({}) do |h, ticket|
    ti = ticket.split(",").map(&:to_i)
    if !ti.filter { |v| rules.all? { |rule| rule[:ranges].any? { |r| r.include?(v) } } }.empty?
      h[index] = { ticket: ticket }
      ti.each.with_index do |v, i|
        applicable = rules.filter { |rule| rule[:ranges].any? { |r| r.include?(v) } }
        applicable.each do |rule|
          h[index][i] ||= applicable
        end
      end
    end
    index += 1
    h
  end
end

def parse_input(input)
  input[0].split("\n").map do |rule|
    p = rule.split(":")
    rule_name = p.first
    rule_ranges = p.last.split("or").map { |r| Range.new(*r.split("-").map(&:to_i)) }
    rule_ranges
    {
      name: rule_name,
      ranges: rule_ranges,
    }
  end
end

part 1 do
  input = test_input
  input = get_raw(2020,16).split("\n\n")
  rules = parse_input(input)
  error_rate(input, rules, 0)
end

part 2 do
  input = test_input2
  input = get_raw(2020,16).split("\n\n")
  rule_ranges = parse_input(input)
  valid_tickets = error_filter(input, rule_ranges)

  # Map each ticket to a set of possible fields.
  res = valid_tickets.reduce({}) do |r, (t_num, t_data)|
    t_data.keys[1..].each do |pos|
      s = Set.new(t_data[pos].map { |k,_| k[:name] })
      r[pos] ||= s
      r[pos] &= s
    end
    r
  end

  # Identify tickets whose Set of possible fields contains only 1 value.
  singles = res.select { |r,s| s.length == 1 }.reduce({}) { |h, (pos, s)| h[pos] = s; h }
  not_finished = true
  while not_finished
    singles = res.select { |p, s| s.length == 1 }
    to_reduce = res.reject { |p, s| s.length == 1 }

    not_finished = false if to_reduce.length == 0

    to_reduce.each do |(pos, s)|
      singles.each do |(pos, r_s)|
        s -= r_s
      end
      res[pos] = s
    end
  end

  ticket = input[1].split("\n")[1].split(",").map(&:to_i)
  res.select { |p, s| s.to_s.match?(/departure/) }.reduce(1) { |r, (p, _)| r *= ticket[p]; r }
end

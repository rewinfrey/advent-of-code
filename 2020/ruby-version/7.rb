require_relative "util"

part 1 do
  rule_regex = /(\w+\s\w+)\sbags?/
  target = "shiny gold"

  def find_target(grammar, target, subgraph)
    return false unless subgraph
    subgraph.any? do |bag|
      if target == bag
        true
      else
        find_target(grammar, target, grammar[bag])
      end
    end
  end

  grammar = get_input(2020,7).reduce({}) do |grammar, rule|
    if rule_regex.match?(rule)
      res = rule.scan(rule_regex).flatten
      grammar[res.first] = res[1..]
    end
    grammar
  end

  grammar.reduce(0) do |found, bags|
    found += 1 if find_target(grammar, target, bags.last)
    found
  end
end

part 2 do
  parent = /(\w+\s\w+)\sbags contain/
  subgraph = /(\d)\s(\w+\s\w+)/
  target = "shiny gold"

  grammar = get_input(2020,7).reduce({}) do |grammar, rule|
    if parent.match?(rule)
      grammar[rule.scan(parent).flatten.first] = rule.scan(subgraph).reduce({}) { |h, (num, bag)| h[bag] = num.to_i; h }
    end
    grammar
  end

  def traverse(grammar, r)
    grammar[r].reduce(0) do |bags, (subr, c)|
      result = traverse(grammar, subr)
      bags += result == 0 ? c : c * result + c
      bags
    end
  end

  traverse(grammar, target)
end

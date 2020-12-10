require_relative "util"

part 1 do
  current_jolt = 0
  res = {
    one_jolts: 0,
    three_jolts: 1,
  }
  get_input(2020,10).map(&:to_i).sort.each do |jolt|
    if current_jolt >= (jolt - 3)
      case jolt - current_jolt
      when 1 then res[:one_jolts] += 1
      when 3 then res[:three_jolts] += 1
      end

      current_jolt = jolt
    end
  end

  res[:one_jolts] * res[:three_jolts]
end

# Originally I tried to do this through brute force and recursion, which worked on the smaller input examples.
# But this combinatoric problem quickly grows when trying to brute force the solution.
part 2 do
  get_input(2020,10).map(&:to_i).sort.reduce({0 => 1}) do |map, adapter|
    # the current adapter is reachable from adapters whose value is less than 3 or more.
    # using a map to cache each adapter's possible configurations based on the previous adapters,
    # it's possible to count the number of configurations for the current adapater in a single pass
    # over the sorted list of adapters.
    map[adapter] = [*1..3].reduce(0) { |sum, comparator| sum += (map[adapter - comparator] || 0) }
    map
  end.values.last
end

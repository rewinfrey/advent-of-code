require_relative "util"
require 'set'

part 1 do
  get_raw(2020, 6).split("\n\n").inject(0) do |sum, group|
    sum += group.strip.tr("\n", "").split("").to_set.length
  end
end

part 2 do
  get_raw(2020, 6).split("\n\n").inject(0) do |sum, group|
    sum += group.strip.split.inject({}) do |res, i|
      i.split("").each { |q| res[q] ||= 0; res[q] += 1 }
      res
    end.filter { |_, c| c == group.strip.split.length }.length
  end
end

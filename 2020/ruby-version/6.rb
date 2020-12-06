require_relative "util"
require 'set'

part 1 do
  get_raw(2020, 6).split("\n\n").inject(0) do |sum, group|
    sum += group.strip.tr("\n", "").split("").to_set.length
  end
end

part 2 do
  get_raw(2020, 6).split("\n\n").inject(0) do |sum, group|
    sum += group.strip.split.reduce(group.strip.split.first.split("").to_set) do |set, i|
      set & i.split("").to_set
    end.length
  end
end

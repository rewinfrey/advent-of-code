require_relative "util"

def test_input
"Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10".split("\n\n")
end

def parse(input)
  parts = input.split(":\n")
  [parts.first, parts.last.split("\n").map(&:to_i)]
end

def calculate_score(deck)
  deck.reverse.each_with_index.reduce(0) do |s, (n, i)|
    s += n * (i + 1)
    s
  end
end

part 1 do
  input = test_input
  input = get_raw(2020,22).split("\n\n")

  (p1, p1_deck) = parse(input.first)
  (p2, p2_deck) = parse(input.last)

  while p1_deck.any? && p2_deck.any?
    one = p1_deck.shift
    two = p2_deck.shift

    case one > two
    when true
      p1_deck << one.clone << two.clone
    when false
      p2_deck << two.clone << one.clone
    end

  end

  case
  when p1_deck.any?
    calculate_score(p1_deck)
  when p2_deck.any?
    calculate_score(p2_deck)
  end
end

def play(p1_deck, p2_deck)
  memoize = Set.new
  while p1_deck.any? && p2_deck.any?
    # First attempt was to use a Hash[p1_deck] = p2_deck,
    # But this was too slow. Switching to Marhsal and Set,
    # makes this operation much faster.
    key = Marshal.dump([p1_deck, p2_deck])
    if memoize.include?(key)
      return "one"
    end
    memoize.add(key)

    one = p1_deck.shift
    two = p2_deck.shift

    if p1_deck.length >= one && p2_deck.length >= two
      case play(p1_deck[0..one-1], p2_deck[0..two-1])
      when "one"
        p1_deck << one.clone << two.clone
      when "two"
        p2_deck << two.clone << one.clone
      end
    else
      case one > two
      when true
        p1_deck << one.clone << two.clone
      when false
        p2_deck << two.clone << one.clone
      end
    end
  end

  if p1_deck.any?
    return "one"
  else
    return "two"
  end
end

part 2 do
  input = test_input
  input = get_raw(2020,22).split("\n\n")

  (p1, p1_deck) = parse(input.first)
  (p2, p2_deck) = parse(input.last)

  play(p1_deck, p2_deck)

  case
  when p1_deck.any?
    calculate_score(p1_deck)
  when p2_deck.any?
    calculate_score(p2_deck)
  end
end

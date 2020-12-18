require_relative "util"

def test_input
"1 + 2 * 3 + 4 * 5 + 6
1 + (2 * 3) + (4 * (5 + 6))
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2".split("\n")
end

class StackFrame
  attr_accessor :left, :op, :right

  def eval
    op.eval.(left.eval, right.eval)
  end
end

class Number
  attr_reader :num

  def initialize(num)
    @num = num
  end

  def eval
    num
  end
end

class Add
  def eval
    ->(a,b) { a + b }
  end
end

class Mult
  def eval
    ->(a,b) { a * b }
  end
end

part 1 do
  programs = get_input(2020,18).map do |line|
  # programs = test_input.map do |line|
    current_sf = StackFrame.new
    stack = []
    line.split("").reduce([current_sf]) do |stack, c|
      case c
      when "("
        current_sf = stack.pop
        if current_sf.left.nil?
          sf_prime = StackFrame.new
          stack.push(current_sf)
          stack.push(sf_prime)
        elsif current_sf.right.nil?
          sf_prime = StackFrame.new
          stack.push(current_sf)
          stack.push(sf_prime)
        else
          raise "impossible for #{current_sf} with #{c} value"
        end
      when ")"
        last_sf = stack.pop
        current_sf = stack.pop
        if current_sf.left.nil?
          current_sf.left = last_sf
        else
          current_sf.right = last_sf
        end
        stack.push(current_sf)
      when "+"
        current_sf = stack.pop
        if current_sf.op.nil?
          current_sf.op = Add.new
          stack.push(current_sf)
        else
          sf_prime = StackFrame.new
          sf_prime.left = current_sf
          sf_prime.op = Add.new
          stack.push(sf_prime)
        end
      when "*"
        current_sf = stack.pop
        if current_sf.op.nil?
          current_sf.op = Mult.new
          stack.push(current_sf)
        else
          sf_prime = StackFrame.new
          sf_prime.left = current_sf
          sf_prime.op = Mult.new
          stack.push(sf_prime)
        end
      when " "
      else
        current_sf = stack.pop
        if current_sf.left.nil?
          current_sf.left = Number.new(c.to_i)
          stack.push(current_sf)
        elsif current_sf.right.nil?
          current_sf.right = Number.new(c.to_i)
          stack.push(current_sf)
        else
          raise "impossible for #{current_sf} with #{c.to_i} value (in else)"
        end
      end
      stack
    end
  end
  programs.map { |p| p.first.eval }.sum
end

def calc_output(output)
  stack = []
  output.each do |c|
    if c == "+" || c == "*"
      x = stack.pop
      y = stack.pop
      v = c == "+" ? x + y : x * y
      stack.push(v)
    else
      stack.push(c)
    end
  end
  stack.first
end

part 2 do
  # test_input.map do |line|
  get_input(2020,18).map do |line|
    ops = {
      "+" => 2,
      "*" => 1,
    }
    output = []
    operator = []

    # Uses the "Shunting yard algorithm" https://en.wikipedia.org/wiki/Shunting-yard_algorithm
    line.split("").each do |c|
      case
      when c == " "
      when c.match?(/\d+/)
        output.push(c.to_i)
      when c.match?(/\*|\+/)
        while (operator.any? && operator.last != '(' && ops[operator.last] >= ops[c])
          output.push(operator.pop)
        end
        operator.push(c)
      when c == "("
        operator.push(c)
      when c == ")"
        while (operator.last != '(')
          output.push(operator.pop)
        end
        if operator.last == '('
          operator.pop
        end
      end
    end

    # Reverse is used here to iterate the operator stack as a stack, rather than an array.
    operator.reverse.each { |op| output.push(op) }

    calc_output(output)
  end.sum
end

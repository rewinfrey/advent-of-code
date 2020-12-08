require_relative "util"

part 1 do
  def evaluate(program, evaluator, state = nil)
    if state.nil?
      state = {
        current_line: 0,
        acc: 0,
        visited: [],
      }
    end

    return state if state[:visited].include?(state[:current_line])

    op = program[state[:current_line]].scan(/^\w+/).first
    arg = program[state[:current_line]].scan(/[+-]\d+/).first.to_i
    state[:visited] << state[:current_line]

    evaluator[op].call(program, arg, state)
  end

  evaluator = {
    "jmp" => -> (program, line, state) do
      current_line = state[:current_line]
      state[:current_line] += line
      evaluate(program, evaluator, state)
    end,
    "acc" => -> (program, num, state) do
      state[:acc] ||= 0
      state[:acc] += num
      state[:current_line] += 1
      evaluate(program, evaluator, state)
    end,
    "nop" => -> (program, arg, state) do
      state[:current_line] += 1
      evaluate(program, evaluator, state)
    end,
  }

  input =
"nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"

  program = input.split("\n")
  program = get_input(2020,8)

  evaluate(program, evaluator)
end

part 2 do
  def evaluate(program, evaluator, state = nil)
    if state.nil?
      state = {
        current_line: 0,
        acc: 0,
        visited: [],
      }
    end

    return state if state[:visited].include?(state[:current_line])

    if program[state[:current_line]].nil?
      state[:completed] = true
      return state
    end

    op = program[state[:current_line]].scan(/^\w+/).first
    arg = program[state[:current_line]].scan(/[+-]\d+/).first.to_i
    state[:visited] << state[:current_line]

    evaluator[op].call(program, arg, state)
  end

  evaluator = {
    "jmp" => -> (program, line, state) do
      current_line = state[:current_line]
      state[:current_line] += line
      evaluate(program, evaluator, state)
    end,
    "acc" => -> (program, num, state) do
      state[:acc] ||= 0
      state[:acc] += num
      state[:current_line] += 1
      evaluate(program, evaluator, state)
    end,
    "nop" => -> (program, arg, state) do
      state[:current_line] += 1
      evaluate(program, evaluator, state)
    end,
  }

  input =
"nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"

  program = input.split("\n")
  program = get_input(2020,8)

  def permutate(program, evaluator)
    indices = []
    program.each_with_index do |line, index|
      indices << index unless line.scan(/^nop|jmp/).empty?
    end

    indices.each do |index|
      new_program = program.map(&:clone)
      new_program[index][0..2] = program[index][0..2] == "jmp" ? "nop" : "jmp"
      state = evaluate(new_program, evaluator)
      return state if state[:completed]
    end
  end

  # program = get_input(2020,8)

  permutate(program, evaluator)
end

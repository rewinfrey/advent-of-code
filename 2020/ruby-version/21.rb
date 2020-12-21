require_relative "util"

def test_input
"mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)".split("\n")
end

def parse(line)
  parts = line.split(" (")
  ingredients = parts.first.split(" ")
  allergens = parts.last.gsub(/contains\s|\)/, "").split(",").map(&:strip)
  [allergens, ingredients]
end

def analyze_food(input)
  map = {
    allergens: Set.new,
    ingredients: Set.new,
    lines: [],
    reduced_allergens: {},
    reduced_ingredients: Set.new,
  }

  input.each_with_index.reduce(map) do |h, (line, l_number)|
    (allergens, ingredients) = parse(line)
    h[:lines][l_number] = {
      :allergens => Set.new,
      :ingredients => Set.new,
    }
    allergens.each   { |a| h[:allergens].add(a); h[:reduced_allergens][a] ||= Set.new; h[:lines][l_number][:allergens].add(a) }
    ingredients.each { |i| h[:ingredients].add(i); h[:lines][l_number][:ingredients].add(i) }
    h
  end

  map[:lines].each do |food|
    # For each food item, compare its allergens / ingredients with other known foods.
    # Remove ingredients associated with an allergen if the ingredient is not found in other food with the same allergen.
    food[:allergens].each do |allergen|
      food[:ingredients].each do |ingredient|

        valid = map[:lines].all? do |search|
          if search[:allergens].include?(allergen)
            search[:ingredients].include?(ingredient)
          else
            true
          end
        end

        if valid
          map[:reduced_allergens][allergen].add(ingredient)
        else
          map[:reduced_allergens][allergen].delete(ingredient)
        end
      end
    end
  end

  map[:reduced_allergens].each do |allergen, s|
    s.each { |ingredient| map[:reduced_ingredients].add(ingredient) }
  end

  map[:missing_ingredients] = map[:ingredients] - map[:reduced_ingredients]

  map
end

part 1 do
  input = test_input
  input = get_input(2020,21)
  results = analyze_food(input)
  results[:lines].inject(0) { |s, search| s += search[:ingredients].intersection(results[:missing_ingredients]).count; s }
end

part 2 do
  input = test_input
  input = get_input(2020,21)
  results = analyze_food(input)
  fix_point = false
  while !fix_point
    reduced = results[:reduced_allergens].select { |_, s| s.length == 1 }
    to_reduce = results[:reduced_allergens].select { |_, s| s.length > 1 }
    fix_point = true
    reduced.each do |_, r|
      to_reduce.each do |_, t|
        if t.intersect?(r)
          fix_point = false
          t.delete(r.first)
        end
      end
    end
  end

  results[:reduced_allergens].select { |_, s| s.length == 1 }.sort { |(a1, _), (b1, _)| a1 <=> b1 }.map { |a, i| i.first }.join(",")
end

defmodule Solution do
    def check_rules?(rule_map, previous, value) do
        rules = rule_map |> Map.get(value, [])
        MapSet.disjoint?(MapSet.new(rules), MapSet.new(previous))
    end

    def get_bad_updates(rule_map, update_list) do
        update_list
            |> Enum.filter(
                fn update -> not(update
                    |> Enum.with_index
                    |> Enum.map(fn {element, index} -> check_rules?(rule_map, MapSet.new(update |> Enum.take(index)), element) end)
                    |> Enum.all?) end)
    end

    def get_rule_map(rules, a, b) do
        rule_lines = rules |> String.split("\n")
        rule_lines
            |> Enum.group_by(
                fn x -> x |> String.split("|") |> Enum.fetch!(a) |>  String.to_integer end,
                fn x -> x |> String.split("|") |> Enum.fetch!(b) |>  String.to_integer end)
    end

    def get_update_list(updates) do
        for update <- updates |> String.split("\n") do
            update
                |> String.split(",")
                |> Enum.map(fn x -> x |> String.to_integer end)
        end
    end

    def part1(rules, updates) do
        rule_map = get_rule_map(rules, 0, 1)
        update_list = get_update_list(updates)
        bad_updates = get_bad_updates(rule_map, update_list)
        valid_updates = update_list -- bad_updates
        result = valid_updates |>  Enum.map(fn update -> update |> Enum.at(div(length(update)-1, 2)) end) |> Enum.sum
        IO.puts("Part 1: #{result}")
    end

    def can_be_added?(edge_map, assigned, value, possible) do
        rules = edge_map |> Map.get(value, [])
        MapSet.equal?(MapSet.difference(MapSet.intersection(MapSet.new(rules), MapSet.new(possible)), MapSet.new(assigned)), MapSet.new())
    end

    def recursive_top_sort(edge_map, to_assign, assigned, possible) when to_assign |> length > 0 do
        value = to_assign |> Enum.find(fn x -> can_be_added?(edge_map, assigned, x, possible) end)
        recursive_top_sort(edge_map, to_assign -- [value], assigned ++ [value], possible)
    end

    def recursive_top_sort(_edge_map, to_assign, assigned, _possible) when to_assign |> length == 0 do
        assigned
    end

    def top_sort(vertices, edges) do
        reverse_edge_map = get_rule_map(edges, 1, 0)
        recursive_top_sort(reverse_edge_map, vertices, [], vertices)
    end

    def part2(rules, updates) do
        rule_map = get_rule_map(rules, 0, 1)
        update_list = get_update_list(updates)
        bad_updates = get_bad_updates(rule_map, update_list)
        sorted_updates = bad_updates |> Enum.map(fn update -> top_sort(update, rules) end)
        result = sorted_updates |>  Enum.map(fn update -> update |> Enum.at(div(length(update)-1, 2)) end) |> Enum.sum
        IO.puts("Part 2: #{result}")
    end
end

input = File.read!("input")
[rules, updates] = input |> String.split("\n\n", parts: 2)
Solution.part1(rules, updates)
Solution.part2(rules, updates)

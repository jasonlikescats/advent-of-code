def distance_to_distinct_window(input, window_size):
    for i in range(len(input) - window_size + 1):
        window = input[i:i + window_size]

        all_distinct = len(set(window)) == window_size
        if all_distinct:
            return i + window_size

def part1(input):
    return distance_to_distinct_window(input, 4)

def part2(input):
    return distance_to_distinct_window(input, 14)

import functools
import sys

def read_input_file():
    filename = get_input_filename()
    with open(filename) as file:
        lines = [line.rstrip() for line in file]

    return lines

def get_input_filename():
    if len(sys.argv) > 1:
        return sys.argv[1]
    else:
        return "input"

def elf_calories(lines):
    cals = [[]]

    for line in lines:
        if line:
            calories = int(line)
            cals[-1].append(calories)
        else:
            cals.append([])

    return map(sum, cals)

def sum(elf_calories):
    return functools.reduce(lambda x, y: x + y, elf_calories)

def part1(lines):
    return max(elf_calories(lines))

def part2(lines):
    cals_list = list(elf_calories(lines))
    cals_list.sort()
    return sum(cals_list[-3:])

def main():
    lines = read_input_file()
    print(f"Part 1: {part1(lines)}")
    print(f"Part 2: {part2(lines)}")

if __name__ == "__main__":
    main()

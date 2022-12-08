import sys

def read_input_file():
    filename = get_input_filename()
    with open(filename) as file:
        return file.read()

def get_input_filename():
    if len(sys.argv) > 1:
        return sys.argv[1]
    else:
        return "input"

def elf_calories(grouped_lines):
    return [sum(list(map(int, elf_cals.split()))) for elf_cals in grouped_lines]

def part1(grouped_lines):
    return max(elf_calories(grouped_lines))

def part2(grouped_lines):
    cals_list = list(elf_calories(grouped_lines))
    cals_list.sort()
    return sum(cals_list[-3:])

def main():
    groups = read_input_file().split("\n\n")
    print(f"Part 1: {part1(groups)}")
    print(f"Part 2: {part2(groups)}")

if __name__ == "__main__":
    main()

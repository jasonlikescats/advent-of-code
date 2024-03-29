def elf_calories(grouped_lines):
    return [sum(list(map(int, elf_cals.split()))) for elf_cals in grouped_lines]

def part1(input):
    return max(elf_calories(input.split('\n\n')))

def part2(input):
    cals_list = list(elf_calories(input.split('\n\n')))
    cals_list.sort()
    return sum(cals_list[-3:])

import functools

class Rucksack:
    def __init__(self, contents):
        self.comp1 = contents[:len(contents)//2]
        self.comp2 = contents[len(contents)//2:]

    def contents(self):
        return self.comp1 + self.comp2

    def compartments_common(self):
        return intersect_single([self.comp1, self.comp2])

def find_group_common(group_rucksacks):
    return intersect_single(
        map(Rucksack.contents, group_rucksacks)
    )

def intersect_single(lists):
    return set.intersection(*map(set, lists)).pop()

def to_priority(item):
    offset = ord('`') if item.islower() else ord('@') - 26
    return ord(item) - offset

def chunks(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def parse(input):
    return [Rucksack(line) for line in input.split('\n')]

def part1(input):
    priorities = map(
        to_priority,
        map(Rucksack.compartments_common, parse(input))
    )
    return sum(priorities)
    
def part2(input):
    grouped_rucksacks = chunks(parse(input), 3)
    common_items = map(find_group_common, grouped_rucksacks)
    priorities = map(to_priority, common_items)
    return sum(priorities)

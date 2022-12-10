class Rucksack:
    def __init__(self, contents):
        self.comp1 = contents[:len(contents)//2]
        self.comp2 = contents[len(contents)//2:]

    def common(self):
        return (set(self.comp1) & set(self.comp2)).pop()

def to_priority(item):
    offset = ord('`') if item.islower() else ord('@') - 26
    return ord(item) - offset

def parse(input):
    return [Rucksack(line) for line in input.split('\n')]

def part1(input):
    return sum(
        map(
            to_priority,
            map(Rucksack.common, parse(input))
        )
    )
    
def part2(input):
    return -1

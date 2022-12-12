import re

class Cargo:
    def __init__(self, stack_lines):
        count = int(re.findall(r'\d', stack_lines[-1])[-1])
        self.stacks = [[] for i in range(count)]
        
        for line in stack_lines[-2::-1]:
            crates = re.findall(r'    | ?\[(.)\]', line)
            for idx, crate in enumerate(crates):
                if crate:
                    self.stacks[idx].append(crate)

    def apply(self, instruction):
        for step in range(instruction.count):
            crate = self.stacks[instruction.source - 1].pop()
            self.stacks[instruction.dest - 1].append(crate)

    def tops(self):
        return "".join([stack[-1] for stack in self.stacks])

class Instruction:
    def __init__(self, line):
        parts = re.findall(r'move (\d+) from (\d+) to (\d+)', line)
        self.count = int(parts[0][0])
        self.source = int(parts[0][1])
        self.dest = int(parts[0][2])

def parse(input):
    sections = list(input.split('\n\n'))
    return (
        Cargo(sections[0].split('\n')),
        [Instruction(inst) for inst in sections[1].split('\n')]
    )

def part1(input):
    cargo, instructions = parse(input)
    for inst in instructions:
        cargo.apply(inst)
    return cargo.tops()
    
def part2(input):
    return -1

from abc import ABC, abstractmethod
import re

class Crane(ABC):
    def __init__(self, stack_lines):
        count = int(re.findall(r'\d', stack_lines[-1])[-1])
        self.stacks = [[] for i in range(count)]
        
        for line in stack_lines[-2::-1]:
            crates = re.findall(r'    | ?\[(.)\]', line)
            for idx, crate in enumerate(crates):
                if crate:
                    self.stacks[idx].append(crate)

    @abstractmethod
    def apply(self, instruction):
        pass

    def stack_tops(self):
        return "".join([stack[-1] for stack in self.stacks])

class CrateMover9000(Crane):
    def apply(self, instruction):
        for step in range(instruction.count):
            crate = self.stacks[instruction.source - 1].pop()
            self.stacks[instruction.dest - 1].append(crate)

class CrateMover9001(Crane):
    def apply(self, instruction):
        crates = self.stacks[instruction.source - 1][-instruction.count:]
        del self.stacks[instruction.source - 1][-instruction.count:]
        self.stacks[instruction.dest - 1].extend(crates)

class Instruction:
    def __init__(self, line):
        parts = re.findall(r'move (\d+) from (\d+) to (\d+)', line)
        self.count = int(parts[0][0])
        self.source = int(parts[0][1])
        self.dest = int(parts[0][2])

def parse(input, craneClass):
    sections = list(input.split('\n\n'))
    return (
        craneClass(sections[0].split('\n')),
        [Instruction(inst) for inst in sections[1].split('\n')]
    )

def move_some_crates(input, craneClass):
    crane, instructions = parse(input, craneClass)
    for inst in instructions:
        crane.apply(inst)
    return crane.stack_tops()

def part1(input):
    return move_some_crates(input, CrateMover9000)
    
def part2(input):
    return move_some_crates(input, CrateMover9001)

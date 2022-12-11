class Assignments:
    def __init__(self, description):
        sections = description.split(',')
        self.section1 = tuple(map(int, sections[0].split('-')))
        self.section2 = tuple(map(int, sections[1].split('-')))

    def has_full_overlap(self):
        return (
            self.check_sections_overlap(self.section1, self.section2) or
            self.check_sections_overlap(self.section2, self.section1)
        )

    def check_sections_overlap(self, x, y):
        return x[0] >= y[0] and x[1] <= y[1]

#section1: ('13', '93')
#section2: ('5', '12')

def part1(input):
    assignments = map(Assignments, input.split('\n'))
    overlapping = list(filter(Assignments.has_full_overlap, assignments))
    return len(overlapping)
    
def part2(input):
    return 0

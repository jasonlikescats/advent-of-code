class Game:
    def __init__(self, theirs, mine):
        self.theirs = theirs
        self.mine = mine

    def score(self):
        return self.shape_selection_score() + self.outcome_score()
        
    def shape_selection_score(self):
        return ord(self.mine) - ord('X') + 1

    def outcome_score(self):
        delta = ord(self.mine) - ord(self.theirs)
        
        if delta == Game.draw_distance():
            return 3

        if self.mine == 'X':
            return 0 if self.theirs == 'B' else 6
        if self.mine == 'Y':
            return 0 if self.theirs == 'C' else 6
        if self.mine == 'Z':
            return 0 if self.theirs == 'A' else 6
    
    @classmethod
    def draw_distance(self):
        return ord('X') - ord('A')

class AssumedGame(Game):
    def __init__(self, strategy_line):
        super().__init__(strategy_line[0], strategy_line[-1])

class CorrectGame(Game):
    def __init__(self, strategy_line):
        their_move = strategy_line[0]
        outcome = strategy_line[-1]
        my_move = CorrectGame.determine_move(their_move, outcome)

        super().__init__(their_move, my_move)

    @classmethod
    def determine_move(cls, theirs, outcome):
        theirs_val = ord(theirs)
        if outcome == 'X': # lose
            offset = (theirs_val - ord('A') + 2) % 3
            return chr(ord('X') + offset)
        if outcome == 'Y': # draw
            return chr(theirs_val + Game.draw_distance())
        if outcome == 'Z': # win
            offset = (theirs_val - ord('A') + 1) % 3
            return chr(ord('X') + offset)

def parse_games(input, klass):
    return [klass(strategy) for strategy in input.split('\n')]
    
def part1(input):
    games = parse_games(input, AssumedGame)
    return sum(map(Game.score, games))

def part2(input):
    games = parse_games(input, CorrectGame)
    return sum(map(Game.score, games))

class DirTree:
    def __init__(self, name, parent):
        self.size = 0
        self.name = name
        self.parent = parent
        self.children = []
    
    def abs_path(self):
        if self.parent:
            return f'{self.parent.abs_path()}/{self.name}'
        else:
            return self.name

    def calculate_recursive_sizes(self, dir_sizes):
        for c in self.children:
            c.calculate_recursive_sizes(dir_sizes)

        abs_path = self.abs_path()
        child_sizes = [dir_sizes[f'{abs_path}/{c.name}'] for c in self.children]
        accumulated_size = self.size + sum(child_sizes)
        dir_sizes[abs_path] = accumulated_size

    def track_file(self, file_size):
        self.size += file_size

    def track_dir(self, dir_name):
        self.children.append(
            DirTree(dir_name, self)
        )

    def change_dir(self, path):
        match path:
            case '..':
                return self.change_to_parent_dir()
            case _:
                return self.change_to_child_dir(path)

    def change_to_child_dir(self, name):
        return next(child for child in self.children if child.name == name)

    def change_to_parent_dir(self):
        return self.parent  

class TerminalParser:
    def parse(self, lines):
        root = DirTree('/', None)
        current = root

        # Skip the first line; little bit of a cheat to get around needing
        # to deal with the '$ cd /'. We'll just initialize our root dir ahead
        # of time with the knowledge that it's always first for our input.
        for line in lines[1:]:
            if line[0:2] == '$ ':
                current = self.parse_command(line[2:], current)
            else:
                self.parse_output(line, current)
        
        return root

    def parse_command(self, command, current_dir):
        match command.split():
            case ['cd', path]:
                return current_dir.change_dir(path)
            case ['ls']:
                return current_dir

    def parse_output(self, line, current_dir):
        match line.split():
            case ['dir', path]:
                current_dir.track_dir(path)
            case [size, _path]:
                current_dir.track_file(int(size))

def part1(input):
    root_dir = TerminalParser().parse(input.split('\n'))

    sizes = {}
    root_dir.calculate_recursive_sizes(sizes)

    small_dir_sizes = [v for _, v in sizes.items() if v <= 100000]
    return sum(small_dir_sizes)

def part2(input):
    return -1

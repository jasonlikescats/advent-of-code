import argparse
import importlib
import lib.file_parsing

def main():
    args = parse_args()

    module_dir = f'day{args.day.zfill(2)}'
    file_path = f'./{module_dir}/{args.file}'
    file_contents = lib.file_parsing.read_input_file(file_path)

    module_name = f'{module_dir}.solution'
    day_module = importlib.import_module(module_name)

    print(f"Part 1: {day_module.part1(file_contents)}")
    print(f"Part 2: {day_module.part2(file_contents)}")
    
def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--day')
    parser.add_argument('-f', '--file', default='input')

    return parser.parse_args()

if __name__ == '__main__':
    main()

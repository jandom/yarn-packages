import sys
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--disallowed', default='packages/disallowed-packages.txt')
args = parser.parse_args()

def get_package(line):
    tokens = line.split()
    name, version_b, version_b, desired_version = tokens[:4]
    package = {
        'name': name,
        'desired_version': desired_version,
    }
    return package

def get_package_line(package):
    package_line = "{}@{}\n".format(package['name'], package['desired_version'])
    return package_line

def read_disallow_packages(filename):
    disallowed_packages = []
    with open(filename, 'r') as f:
        lines = f.readlines()
        disallowed_packages = [l.strip() for l in lines]
    return disallowed_packages

def get_is_allowed(package_name, disallowed_packages):
    violations = [ 1 for disallowed_package in disallowed_packages if disallowed_package in package_name ]
    return sum(violations) == 0

disallowed_packages = read_disallow_packages(args.disallowed)

for line in sys.stdin:
    if 'dependencies' not in line: continue
    package = get_package(line)
    is_allowed = get_is_allowed(package['name'], disallowed_packages)
    if not is_allowed: continue
    package_line = get_package_line(package)
    sys.stdout.write(package_line)

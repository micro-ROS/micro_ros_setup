#! /usr/bin/env python

import yaml

import sys

import copy

if __name__ == '__main__':
    repos_info = yaml.load(sys.stdin)
    repos_keep = yaml.load(file(sys.argv[1]))

    target = {'repositories': {}}

    for key in repos_info["repositories"]:
        if key in repos_keep['keep']:
            target['repositories'][key] = repos_info["repositories"][key]

    print(yaml.dump(target))
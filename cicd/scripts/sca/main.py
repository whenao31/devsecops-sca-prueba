import os
import subprocess
import sys, getopt
from util import check_docker, get_sca_opt, parse_markdowntable_to_json


def main(argv=None):
    
    # rm_previous_file_cmd = "[ ! -e sca_result.md ] || rm sca_result.md"
    # print(os.system(rm_previous_file_cmd))

    lockfile = get_sca_opt(argv)

    docker_sca_cmd = f'docker run -it -v ${{PWD}}:/src ghcr.io/google/osv-scanner --format markdown -L /src/{lockfile} > sca_result.md'
    os.system(docker_sca_cmd)

    with open('sca_result.md', "r") as file:
        head, tail = file.read().split('\n', 1)
  
    if tail.find("OSV URL") != -1:
        with open('sca_result.md', "w") as fout:
            fout.write(tail)
    else:
        print('\n*** SCA Result Warn ***')
        print(head, '\n', tail)
    
    print(parse_markdowntable_to_json('sca_result.md'))    
    

if __name__ == '__main__':

    check_docker()
    main(sys.argv[1:])
    print('executed ;)')
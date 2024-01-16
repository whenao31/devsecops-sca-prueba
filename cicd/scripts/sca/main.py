import json
import os
import sys
from util import check_docker, get_sca_opt, parse_markdowntable_to_json
from http_request import post_sca_result


def main(argv):
    
    # rm_previous_file_cmd = "[ ! -e sca_result.md ] || rm sca_result.md"
    # print(os.system(rm_previous_file_cmd))

    # Obtain all the args from command line
    lockfile, ci_exec_id, git_branch, git_user, sca_api_url, sca_api_token  = get_sca_opt(argv)
    
    # docker_sca_cmd = f'docker run -it -v ${{PWD}}:/src ghcr.io/google/osv-scanner --format markdown -L /src/{lockfile} > sca_result.md'
    # os.system(docker_sca_cmd)

    with open('sca_result.md', "r") as file:
        head, tail = file.read().split('\n', 1)
  
    # Check whether there's a Table of Results to be sent to the SCA service API
    if tail.find("OSV URL") != -1:
        with open('sca_result.md', "w") as fout:
            fout.write(tail)
    
        # Parse data to send to Vulnerability Management Platform(VMP)
        data  = parse_markdowntable_to_json('sca_result.md', execution_id=ci_exec_id,
                                        git_branch=git_branch, git_user=git_user
                )
        
        # POST Request of the SCA results to the SCA service at VMP
        post_sca_result(sca_api_url, data, sca_api_token)
    else:
        print('\n*** SCA Result Warn ***')
        print(head, '\n', tail)
    
    

if __name__ == '__main__':

    check_docker()
    main(sys.argv[1:])
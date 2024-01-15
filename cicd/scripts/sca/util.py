import os
import subprocess
import sys, getopt
import json

def check_docker():
    '''Function that verifies whether Docker engine
       is up and running locally.
    Args:
    Returns: None
    '''
    try :
        # os.system("docker version")
        check_docker = subprocess.run("docker version".split(),capture_output=True).returncode
        if check_docker != 0:
            print("It seems neither docker engine is installed nor dockerd is running!")
            sys.exit(2)
        print('Docker engine OK.')
    except OSError as error:
        print(error)
    
    return None

def get_sca_opt(argv):
    '''Function that parses command-line options and arguments
       to get the 'lockfile' path used for the SCA.
    Args:
        argv: arguments coming from the command-line
    Returns: 
        lockfile_path
    '''
    lockfile_path   = ''
    ci_exec_id      = ''
    git_branch      = ''
    git_user        = ''
    sca_api_url     = ''

    try:
        long_options = ["lockfile=", "ci-exec-id=", "git-branch", "git-user", "sca-api-url"]
        opts, args = getopt.getopt(argv, "hL:i:b:u:a:", long_options)
    except getopt.GetoptError:
        print("sca.py -L [lockfile/path] -i [ci-execution-id] -b [git-branch] -u [git-user] -a [sca-api-url]")
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print ('sca.py -L [lockfile/path] -i [ci-execution-id] -b [git-branch] -u [git-user] -a [sca-api-url]')
            sys.exit()
        elif opt in ('-L', "--lockfile"):
            lockfile_path = arg
        elif opt in ('-i', "--ci-exec-id"):
            ci_exec_id = arg
        elif opt in ('-b', "--git-branch"):
            git_branch = arg
        elif opt in ('-u', "--git-user"):
            git_user = arg
        elif opt in ('-a', "--sca-api-url"):
            sca_api_url = arg
    
    return lockfile_path, ci_exec_id, git_branch, git_user, sca_api_url


def parse_markdowntable_to_json(filename, **kwargs):
    """Parses text separated by '|' within a file into a JSON object.

    Args:
        filename: name of the file containing the text to parse.
        kwarg.execution_id: Hash from the cicd execution
        kwarg.git_branch: Git branch of the analized lockfile repository
        kwarg.git_user: User who executed the cicd pipeline
    Returns:
        A JSON object representing the parsed data.
    """

    with open(filename, "r") as file:
        text = file.read()

    lines = text.splitlines()
    headers = [header.strip().replace(' ','_').lower() for header in lines[0][1:len(lines[0]) - 1].split("|")]
    data = []

    for line in lines[2:]:
        fields = [field.strip() for field in line[1:len(line) - 1].split("|")]
        entry = dict(zip(headers, fields))
        data.append(entry)
    
    data_dict = {'vulnerabilities': data}
    for key, value in kwargs.items():
        data_dict[key] = value

    return json.dumps(data_dict, indent=4)
import os
import pathlib
import sys
import re
import json
import onlinejudge.utils as utils

CONFIG_FILE='oj_settings.json'

def read_confug_url():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE) as file:
            obj = json.load(file)
            if obj["url"]:
                return obj["url"]
            else:
                print(f"no url configuration in {CONFIG_FILE}")
    else:
        print(f'config file({CONFIG_FILE}) does not exist')

    return None

def target_url():
    url = read_confug_url()
    if url:
        return url

    base_dir = pathlib.Path(os.getcwd())

    result = re.match(r'([a-z]+)-?([0-9a-z]+).*_([a-z])', base_dir.name)
    if result:
        contest_type = result.group(1)
        contest_num = result.group(2)
        problem = result.group(3)
        result = re.match(r'^(joi[0-9]+)([a-z0-9]+)', contest_type + contest_num)
        if result:
            print('JOI contests')
            joi_year = result.group(1)
            joi_type = result.group(2)
            print(f'AtCoder JOI contest year:{joi_year} type:{joi_type}')
            return f'https://atcoder.jp/contests/{joi_year}{joi_type}/tasks/{joi_year}_{joi_type}_{problem}'
        else:
            print(f'AtCoder contest:{contest_type} num:{contest_num} problem:{problem}')
            return f'https://atcoder.jp/contests/{contest_type}{contest_num}/tasks/{contest_type}{contest_num}_{problem}'
    else:
        print(f'cannot resolve problem from dir {base_dir}')


    return None

if len(sys.argv) < 2:
    print("usage: oj_helper [ds] [main.cpp]")
    sys.exit(1)

url = target_url()

if not url:
    print("cannot resolve target url")
    sys.exit(1)

if sys.argv[1] == 'd':
    cmd = f'oj d {url}'
    # print(cmd)
    os.system(cmd)
elif sys.argv[1] == 's':
    lang = ''
    # if re.match(r'^https://atcoder.jp/', url):
    #     lang = '-l 5031'

    cmd = f'oj s {lang} -y {url} {sys.argv[2]}'
    # print(cmd)
    os.system(cmd)
elif sys.argv[1] == 'l':
    cmd = f'oj l {url}'
    os.system(cmd)
elif sys.argv[1] == 'lo':
    cookie_path = utils.default_cookie_path
    print(f'log out(remove cookie file:{cookie_path})')
    os.remove(cookie_path)
else:
    print(f'unknown action {sys.argv[1]}')

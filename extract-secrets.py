import json
import sys

if __name__ == '__main__':
    inline = sys.argv[1]
    payload = json.loads(''.join(sys.stdin.readlines()))
    secrets = json.loads(payload['SecretString'])
    if inline == 'inline':
        print(" ".join(["{}={}".format(x, json.dumps(v)) for (x, v) in secrets.items()]))
    else:
        print("\n".join(["{}={}".format(x, (json.dumps(v) if '\n' in v else v)) for (x, v) in secrets.items()]))

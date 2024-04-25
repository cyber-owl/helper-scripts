import json
import sys

if __name__ == '__main__':
    payload = json.loads(''.join(sys.stdin.readlines()))
    secrets = json.loads(payload['SecretString'])
    print("\n".join(["{}={}".format(x, (json.dumps(v) if '\n' in v else v)) for (x, v) in secrets.items()]))

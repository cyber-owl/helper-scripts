echo "import json,sys;

if __name__ == '__main__':
  payload = json.loads(''.join(sys.stdin.readlines()))
  secrets = json.loads(payload['SecretString'])
  print(
    '\\\n'.join(
      [
        f'{x}={v}' for (x,v) in secrets.items()
      ]
    )
  )" > extract-secrets.py

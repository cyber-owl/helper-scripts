printf -v OWL_HELPERS_EXTRACT_SECRETS_PY "%q" "import json,sys;

if __name__ == '__main__':
  payload = json.loads(''.join(sys.stdin.readlines()))
  secrets = json.loads(payload['SecretString'])
  print(
    '\\\n'.join(
      [
        f'{x}={v}' for (x,v) in secrets.items()
      ]
    )
  )"

alias  owl-helpers-create-extract-secrets-py="echo $OWL_HELPERS_EXTRACT_SECRETS_PY > extract-secrets.py"

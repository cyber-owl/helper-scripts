function owl-helpers-login-aws() {
  local AWS_ACCOUNT_ID=$1
  local AWS_REGION=${2-ap-northeast-1}
  version=$(echo $(aws --version 2>&1) | sed -e 's/aws-cli\/\([0-9]\{1,\}\).*/\1/')
  if [[ $version -eq 1 ]]; then
    $(aws ecr get-login --no-include-email --region ap-northeast-1)
  elif [[ "$version" -ge 2 ]]; then
    aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
  else
    echo "Error: could not detect aws command version."
    return 1
  fi
}


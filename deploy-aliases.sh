#!/bin/bash
grep -qF -- "__pycache__" ".gitignore" || echo -e "\n__pycache__" >> ".gitignore"
grep -qF -- "merge_unzip" ".gitignore" || echo -e "\nmerge_unzip" >> ".gitignore"
grep -qF -- ".merge_unzip_append" ".gitignore" || echo -e "\n.merge_unzip_append" >> ".gitignore"
grep -qF -- "code_zips" ".gitignore" || echo -e "\ncode_zips" >> ".gitignore"
grep -qF -- "deploy-*" ".gitignore" || echo -e "\ndeploy-*" >> ".gitignore"
grep -qF -- "extract-secrets.py" ".gitignore" || echo -e "\nextract-secrets.py" >> ".gitignore"

unset -f owl-helpers-login-aws 2> /dev/null
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

unset -f owl-helpers-merge-zip 2> /dev/null
function owl-helpers-merge-zip() {
  local compose_service_name=$1
  local INCLUDE_SUBMODULES=$2
  local GIT_HASH=$(git rev-parse --short HEAD)
  local main_repo_name=$(basename "$PWD")
  local main_repo_path=$(pwd)
  

  rm -rf merge_unzip code_zips
  mkdir -p code_zips merge_unzip .merge_unzip_append
  git archive --format=tar.gz --output="./code_zips/${main_repo_name}" HEAD

  if [[ "$INCLUDE_SUBMODULES" == "true" ]]; then
    git submodule foreach 'repo_name=$(basename "$PWD") && parent_dir=$(dirname "$(pwd)") && git archive --format=tar.gz --output="${parent_dir}/code_zips/${repo_name}" HEAD'
  fi

  mkdir -p "./merge_unzip/${main_repo_name}"
  tar -xzvf "code_zips/${main_repo_name}" -C "./merge_unzip/${main_repo_name}"
  for zip_path in code_zips/*; do
    repo_name="${zip_path#code_zips/}"
    if [ "$main_repo_name" != "$repo_name" ]; then
      mkdir -p "./merge_unzip/${main_repo_name}/${repo_name}"
      tar -xzvf ${zip_path} -C "./merge_unzip/${main_repo_name}/${repo_name}"
    fi
  done
  \cp -rf .merge_unzip_append/ merge_unzip/${main_repo_name}/
  cd merge_unzip/${main_repo_name}
  zip -rA "${main_repo_path}/deploy-${GIT_HASH}.zip" .
  cd ${main_repo_path}
  aws s3 cp deploy-${GIT_HASH}.zip "s3://deploy-zip-sources/${main_repo_name}/${compose_service_name}/${GIT_HASH}.zip"
  rm -rf code_zips merge_unzip .merge_unzip_append deploy-${GIT_HASH}.zip
}

unset -f owl-helpers-validate-git-branch 2> /dev/null
function owl-helpers-validate-git-branch() {
  local CHECK_BRANCH=$1
  git fetch origin $CHECK_BRANCH
  ORIGIN_MASTER=$(git show-ref origin/$CHECK_BRANCH -s)
  CURRENT=$(git rev-parse HEAD)
  if [[ "$ORIGIN_MASTER" != "$CURRENT" ]]; then
    echo "origin/$CHECK_BRANCH と一致していないのでビルドできません";
    # return error
    return 1
  else
    echo 'git diff をチェックしてビルドします。コミットされてなければビルドできません';
    git diff --exit-code --quiet && git diff --staged --exit-code
  fi
}

unset -f owl-helpers-deploy-zip 2> /dev/null
function owl-helpers-deploy-zip() {
  local CHECK_BRANCH=$1
  local COMPOSE_SERVICE_NAME=$2
  local ECR_REPOSITORY=$3
  local SLACK_CHANNEL_ID=$4
  local SLACK_CHANNEL_NAME=$5
  local INCLUDE_SUBMODULES=${6-false}
  local REPO_NAME=$(basename "$PWD")
  local GIT_HASH=$(git rev-parse --short HEAD)
  
  owl-helpers-validate-git-branch $CHECK_BRANCH \
    && owl-helpers-merge-zip $COMPOSE_SERVICE_NAME $INCLUDE_SUBMODULES \
    && aws codebuild start-build --no-cli-pager \
      --project owl-codebuild \
      --source-location-override deploy-zip-sources/${REPO_NAME}/${COMPOSE_SERVICE_NAME}/${GIT_HASH}.zip \
      --environment-variables-override name=GIT_HASH,value=${GIT_HASH},type=PLAINTEXT \
        name=COMPOSE_SERVICE_NAME,value=${COMPOSE_SERVICE_NAME},type=PLAINTEXT \
        name=REPOSITORY,value=${REPO_NAME},type=PLAINTEXT \
        name=SLACK_CHANNEL_ID,value=${SLACK_CHANNEL_ID},type=PLAINTEXT \
        name=SLACK_CHANNEL_NAME,value=${SLACK_CHANNEL_NAME},type=PLAINTEXT \
        name=ECR_REPOSITORY,value=${ECR_REPOSITORY},type=PLAINTEXT \
        name=IMAGE_TAG,value=${GIT_HASH},type=PLAINTEXT
  # codebuildの通知は以下のlambdaを使用
  # https://ap-northeast-1.console.aws.amazon.com/lambda/home?region=ap-northeast-1#/functions/codebuild-notification?tab=code
}


unset -f owl-helpers-update-or-add-property 2> /dev/null
function owl-helpers-update-or-add-property() {
    local property=$1
    local value=$2
    local file=$3

    # Check if the property exists
    if grep -q "^$property=" "$file"; then
        # Property exists, update it
        # Check if we are on macOS or Linux and use the correct sed syntax
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i "" "s/^$property=.*/$property=$value/" "$file"
        else
            sed -i "s/^$property=.*/$property=$value/" "$file"
        fi
        echo Replaced $property in $file
    else
        # Property does not exist, add it
        echo "$property=$value" >> "$file"
        echo Added $property to $file
    fi
}

unset -f owl-helpers-fetch-secrets 2> /dev/null
function owl-helpers-fetch-secrets() {
  local secret_id=$1
  local file=$2

  if [ -z "$file" ]; then
    curl https://raw.githubusercontent.com/cyber-owl/helper-scripts/main/extract-secrets.py -s -o extract-secrets.py \
    && aws secretsmanager get-secret-value --secret-id $secret_id --region ap-northeast-1 | python3 extract-secrets.py inline
  else
    curl https://raw.githubusercontent.com/cyber-owl/helper-scripts/main/extract-secrets.py -s -o extract-secrets.py \
    && aws secretsmanager get-secret-value --secret-id $secret_id --region ap-northeast-1 | python3 extract-secrets.py > $file \
    && echo Downloaded secrets: $secret_id to $file
  fi
}

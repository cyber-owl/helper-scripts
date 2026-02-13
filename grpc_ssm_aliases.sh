#!/bin/bash

# dev: 踏み台サーバ上で稼働
alias grpc_ssm_dev="start_grpc_ssm_local_session 50151 56501"

# alpha/prd: ECSで稼働
alias grpc_ssm_alpha="start_grpc_ssm_remote_session alpha.grpc.cyberowl.jp 50154 56502"
alias grpc_ssm_prd="start_grpc_ssm_remote_session grpc.cyberowl.jp 50153 56503"

start_grpc_ssm_local_session() {
  local port=$1
  local local_port=$2

  if [ -z "$port" ] || [ -z "$local_port" ]; then
    echo "Usage: start_grpc_ssm_local_session <port> <local_port>"
    return 1
  fi

  echo ""
  echo "gRPC SSM (local): localhost:$port -> localhost:$local_port"
  echo ""
  aws ssm start-session --target i-0da45729586d6513c --document-name AWS-StartPortForwardingSession --parameters "portNumber=$port,localPortNumber=$local_port"
}

start_grpc_ssm_remote_session() {
  local host=$1
  local port=$2
  local local_port=$3

  if [ -z "$host" ] || [ -z "$port" ] || [ -z "$local_port" ]; then
    echo "Usage: start_grpc_ssm_remote_session <host> <port> <local_port>"
    return 1
  fi

  echo ""
  echo "gRPC SSM (remote): $host:$port -> localhost:$local_port"
  echo ""
  aws ssm start-session --target i-0da45729586d6513c --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "host="$host",portNumber=$port,localPortNumber=$local_port"
}

#!/bin/bash
alias rds_ssm_article_stg="start_rds_ssm_session article-stg.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56401"
alias rds_ssm_article_prd_writer="start_rds_ssm_session article.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56402"
alias rds_ssm_article_prd_reader="start_rds_ssm_session article.cluster-ro-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56403"
alias rds_ssm_aukana_prd="start_rds_ssm_session aukana.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56404"
alias rds_ssm_cashing_prd_writer="start_rds_ssm_session cashing2.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56405"
alias rds_ssm_cashing_prd_reader="start_rds_ssm_session cashing2.cluster-ro-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56406"
alias rds_ssm_conv_kickback_prd="start_rds_ssm_session conv-kickback.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56407"
alias rds_ssm_creditcard_prd_writer="start_rds_ssm_session creditcard-prd.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56408"
alias rds_ssm_creditcard_prd_reader="start_rds_ssm_session creditcard-prd.cluster-ro-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56409"
alias rds_ssm_datsumo_prd_writer="start_rds_ssm_session datsumo-prd.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56410"
alias rds_ssm_datsumo_prd_reader="start_rds_ssm_session datsumo-prd.cluster-ro-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56411"
alias rds_ssm_manekai_prd_writer="start_rds_ssm_session manekai-prd.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56412"
alias rds_ssm_manekai_prd_reader="start_rds_ssm_session manekai-prd.cluster-ro-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56413"
alias rds_ssm_micres_prd_writer="start_rds_ssm_session micres-prd.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56414"
alias rds_ssm_micres_prd_reader="start_rds_ssm_session micres-prd.cluster-ro-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56415"
alias rds_ssm_micres_stg="start_rds_ssm_session micres-stg.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56416"
alias rds_ssm_mono_prd="start_rds_ssm_session mono-prd.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56417"
alias rds_ssm_owl_asset_prd="start_rds_ssm_session owl-asset-prd.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56418"
alias rds_ssm_owl_asset_stg="start_rds_ssm_session owl-asset-stg.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56419"
alias rds_ssm_owles_prd="start_rds_ssm_session owles-prd.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56420"
alias rds_ssm_owles_stg="start_rds_ssm_session owles-stg.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56421"
alias rds_ssm_owlowned_prd="start_rds_ssm_session owlowned.c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56422"
alias rds_ssm_owlowned_dev="start_rds_ssm_session owlowned-dev.c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56423"
alias rds_ssm_owlreport_prd="start_rds_ssm_session owlreport.c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 5432 56424"
alias rds_ssm_ss_dev="start_rds_ssm_session ss-dev2.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56425"
alias rds_ssm_vod_prd_writer="start_rds_ssm_session vod2.cluster-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56426"
alias rds_ssm_vod_prd_reader="start_rds_ssm_session vod2.cluster-ro-c9gwik3sd2yz.ap-northeast-1.rds.amazonaws.com 3306 56427"

alias redis_ssm_micres_prd="start_rds_ssm_session oukana-nocluster.n4gbos.0001.apne1.cache.amazonaws.com 6379 56480"

start_rds_ssm_session() {
  local host=$1
  local port=$2
  local local_port=$3

  if [ -z "$host" ] || [ -z "$port" ] || [ -z "$local_port" ]; then
    echo "Usage: start_ssm_session <host> <port> <local_port>"
    return 1
  fi

  echo ""
  echo "RDS SSM: $host:$port -> localhost:$local_port"
  echo ""
  aws ssm start-session --target i-0da45729586d6513c --document-name AWS-StartPortForwardingSessionToRemoteHost  --parameters "host="$host",portNumber=$port,localPortNumber=$local_port"
}
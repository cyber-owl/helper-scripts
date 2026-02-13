# 使い方

## extract-secrets.pyを作成
```bash
curl https://raw.githubusercontent.com/cyber-owl/helper-scripts/main/extract-secrets.py -s -o extract-secrets.py
```

## デプロイ用alias初期化
```bash
curl -s -o deploy-aliases.sh https://raw.githubusercontent.com/cyber-owl/helper-scripts/main/deploy-aliases.sh \
  && source deploy-aliases.sh \
  && rm deploy-aliases.sh
```

## awsリソースへの接続aliasのセットアップ

### RDS
```bash
curl https://raw.githubusercontent.com/cyber-owl/helper-scripts/main/rds_ssm_aliases.sh -s -o ~/rds_ssm_aliases.sh
chmod a+x ~/rds_ssm_aliases.sh
echo -e "\nsource ~/rds_ssm_aliases.sh" >> ~/.zshrc
```

### gRPC
```bash
curl https://raw.githubusercontent.com/cyber-owl/helper-scripts/main/grpc_ssm_aliases.sh -s -o ~/grpc_ssm_aliases.sh
chmod a+x ~/grpc_ssm_aliases.sh
echo -e "\nsource ~/grpc_ssm_aliases.sh" >> ~/.zshrc
```

| 環境 | alias | ローカルポート | リモートホスト |
|------|-------|-------------|--------------|
| dev | `grpc_ssm_dev` | 56501 | stg.grpc.cyberowl.jp:50151 |
| alpha | `grpc_ssm_alpha` | 56502 | alpha.grpc.cyberowl.jp:50154 |
| prd | `grpc_ssm_prd` | 56503 | grpc.cyberowl.jp:50153 |
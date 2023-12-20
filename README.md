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

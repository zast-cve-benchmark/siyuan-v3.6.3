#!/bin/bash
# 等待 SiYuan 启动
echo "等待 SiYuan 启动..."
sleep 10

# 设置 API Token
echo "设置 API Token..."
curl -s -X POST "http://localhost:8090/api/system/setApiToken" \
  -H "Content-Type: application/json" \
  -d '{"accessAuthCode": "vulnerable123", "token": "vulnerable123"}'

echo "初始化完成"
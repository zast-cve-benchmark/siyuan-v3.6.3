#!/usr/bin/env python3
"""
SiYuan 登录脚本
输出认证所需的请求头

用法:
    python login.py --api-base-url http://localhost:8090
    python login.py --api-base-url http://localhost:8090 --conf-dir ./siyuan-data/conf
"""
import argparse
import json
import os
import sys
import requests

requests.packages.urllib3.disable_warnings()


def find_api_token(base_url, access_auth_code):
    """尝试通过 accessAuthCode 获取 API Token"""
    try:
        # 尝试调用设置 API Token 的接口
        url = f"{base_url}/api/system/setApiToken"
        data = {
            "accessAuthCode": access_auth_code,
            "token": "vulnerable123"
        }
        resp = requests.post(url, json=data, timeout=5)
        if resp.status_code == 200:
            result = resp.json()
            if result.get('code') == 0:
                return "vulnerable123"
    except:
        pass
    return None


def main():
    parser = argparse.ArgumentParser(description='SiYuan 登录脚本')
    parser.add_argument('--api-base-url', default='http://localhost:8090',
                        help='API 基础 URL (默认: http://localhost:8090)')
    parser.add_argument('--conf-dir',
                        help='配置文件目录 (默认: 自动检测)')
    parser.add_argument('--access-auth-code', default='vulnerable123',
                        help='访问授权码 (默认: vulnerable123)')

    args = parser.parse_args()

    api_token = None

    # 方式1: 如果提供了 conf-dir，从配置文件读取
    if args.conf_dir and os.path.exists(args.conf_dir):
        conf_file = os.path.join(args.conf_dir, 'conf.json')
        if os.path.exists(conf_file):
            with open(conf_file, 'r') as f:
                conf = json.load(f)
                api_token = conf.get('api', {}).get('token', '')

    # 方式2: 尝试通过 API 获取 token
    if not api_token:
        api_token = find_api_token(args.api_base_url, args.access_auth_code)

    # 方式3: 使用默认 token
    if not api_token:
        # SiYuan 漏洞环境默认使用 vulnerable123 作为 API token
        api_token = "vulnerable123"

    # 输出请求头 (每行一个，无其他内容)
    print(f"Authorization: Token {api_token}")
    print("Content-Type: application/json")


if __name__ == '__main__':
    main()
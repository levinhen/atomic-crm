#!/bin/bash
set -e

RELAY_KEY="sk-TQne5andxfzDYkvH8n7q7B5WgkghDhhvhFg259QVS41XgaZQ"          # 中转站给你的 key，格式通常是 sk-xxx
RELAY_URL="https://api.linkapi.ai" # 中转站地址，如 https://api.tu-zi.com

# === 1. 写入 settings.json（含 env、bypassPermissions）===
mkdir -p ~/.claude
cat > ~/.claude/settings.json << EOF
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "${RELAY_KEY}",
    "ANTHROPIC_BASE_URL": "${RELAY_URL}",
    "API_TIMEOUT_MS": "600000"
  },
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "dangerouslySkipPermissions": true,
  "skipDangerousModePermissionPrompt": true,
  "model": "claude-opus-4-6"
}
EOF

# === 2. 写入 api-key-helper.sh（官方 apiKeyHelper，彻底绕过登录弹窗）===
cat > ~/.claude/api-key-helper.sh << EOF
#!/bin/bash
echo "${RELAY_KEY}"
EOF
chmod +x ~/.claude/api-key-helper.sh

# 把 apiKeyHelper 路径写入 settings.json
# （用 python 做 JSON merge 更安全）
python3 - << PYEOF
import json, os
path = os.path.expanduser("~/.claude/settings.json")
with open(path) as f:
    cfg = json.load(f)
cfg["apiKeyHelper"] = os.path.expanduser("~/.claude/api-key-helper.sh")
with open(path, "w") as f:
    json.dump(cfg, f, indent=2)
PYEOF

# === 3. 写入 .claude.json（跳过 onboarding 的关键）===
LAST20="${RELAY_KEY: -20}"  # 取 key 末尾 20 位，用于信任确认
cat > ~/.claude.json << EOF
{
  "hasCompletedOnboarding": true,
  "skipDangerousModePermissionPrompt": true,
  "customApiKeyResponses": {
    "approved": ["${LAST20}"],
    "rejected": []
  }
}
EOF

echo ""
echo "✅ 配置完成！直接运行 claude 即可，无需登录。"
echo "   BASE_URL : ${RELAY_URL}"
echo "   KEY 末尾 : ...${LAST20}"

#!/bin/bash
set -e

echo ""
echo "================================================"
echo "  🚀 Atomic CRM 环境启动中，请稍候..."
echo "================================================"
echo ""

# ── 1. 拼接 Codespaces 域名 ──
FRONTEND_URL="https://${CODESPACE_NAME}-5173.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
SUPABASE_URL="https://${CODESPACE_NAME}-54321.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"

echo "📍 前端地址: ${FRONTEND_URL}"
echo "📍 Supabase:  ${SUPABASE_URL}"
echo ""

# ── 2. 更新 supabase/config.toml ──
echo "🔧 配置 Supabase CORS..."
sed -i "s|site_url = \".*\"|site_url = \"${FRONTEND_URL}\"|" supabase/config.toml
sed -i "s|additional_redirect_urls = \[\".*\"\]|additional_redirect_urls = [\"${FRONTEND_URL}/auth-callback.html\"]|" supabase/config.toml

# ── 3. 等待 Docker 就绪 ──
echo "⏳ 等待 Docker daemon..."
while ! docker info > /dev/null 2>&1; do
  sleep 1
done
echo "✅ Docker 就绪"
echo ""

# ── 4. 启动 Supabase ──
echo "🗄️  启动 Supabase（首次约 3-5 分钟，拉取镜像请耐心等待）..."
supabase stop 2>/dev/null || true
supabase start 2>&1
echo "✅ Supabase 启动完成"

# ── 5. 获取 anon key ──
ANON_KEY=$(supabase status --output json 2>/dev/null | \
  node -e "let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>console.log(JSON.parse(d).ANON_KEY))")

echo ""
echo "🔑 Anon key 获取成功"

# ── 6. 写入环境变量 ──
cat > .env.development.local << EOF
VITE_SUPABASE_URL=${SUPABASE_URL}
VITE_SB_PUBLISHABLE_KEY=${ANON_KEY}
EOF
echo "📝 .env.development.local 已生成"

# ── 7. 后台启动前端，日志写入文件 ──
echo ""
echo "🌐 启动前端开发服务器..."
nohup npm run dev > /tmp/vite.log 2>&1 &

echo ""
echo "================================================"
echo "  ✅ 环境就绪！"
echo "  🌐 打开：${FRONTEND_URL}"
echo "  📋 Vite 日志：tail -f /tmp/vite.log"
echo "================================================"
echo ""

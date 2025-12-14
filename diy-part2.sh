#!/bin/bash
# =================================================================
# Function: Smart Glider Injection (Auto-detect Arch)
# =================================================================

mkdir -p files/usr/bin
mkdir -p files/etc/init.d
mkdir -p files/etc/uci-defaults

# --- 1. 智能判断架构 ---
# 检查 .config 文件中是否包含 x86_64 的定义
if grep -q "CONFIG_TARGET_x86_64=y" .config; then
    echo "Detected Architecture: x86_64 (AMD64)"
    GLIDER_ARCH="amd64"
else
    # 默认为 ARM64 (适配 AX6)
    echo "Detected Architecture: ARM64"
    GLIDER_ARCH="arm64"
fi

# --- 2. 下载对应版本的 Glider ---
GLIDER_VER="v0.16.3"
GLIDER_URL="https://github.com/nadoo/glider/releases/download/${GLIDER_VER}/glider_${GLIDER_VER##v}_linux_${GLIDER_ARCH}.tar.gz"

echo "Downloading Glider from: $GLIDER_URL"
wget -O glider.tar.gz "$GLIDER_URL"

# 解压并提取
tar -xzvf glider.tar.gz
find . -type f -name "glider" -exec mv {} files/usr/bin/glider \;
rm -rf glider.tar.gz glider_*
chmod +x files/usr/bin/glider

# --- 3. 生成启动脚本 (Procd) ---
# 注意：启动脚本是通用的，不需要改动
cat <<EOF > files/etc/init.d/glider
#!/bin/sh /etc/rc.common

START=99
USE_PROCD=1
PROG=/usr/bin/glider

# 监听 8443，连接本地 1001/1002/1003
ARGS="-listen mixed://:8443 -forward socks5://127.0.0.1:1001 -forward socks5://127.0.0.1:1002 -forward socks5://127.0.0.1:1003 -strategy ha -check=http://www.gstatic.com/generate_204 -checkinterval=30"

start_service() {
    procd_open_instance
    procd_set_param command \$PROG \$ARGS
    procd_set_param respawn
    procd_set_param stdout 0
    procd_set_param stderr 0
    procd_close_instance
}
EOF
chmod +x files/etc/init.d/glider

# --- 4. 设置自动启动 ---
cat <<EOF > files/etc/uci-defaults/99-glider-enable
#!/bin/sh
/etc/init.d/glider enable
exit 0
EOF
chmod +x files/etc/uci-defaults/99-glider-enable

echo "=== Glider Injection ($GLIDER_ARCH) Done ==="

#!/bin/bash
# AX6 专用设置

# 1. 修改默认 IP 为 192.168.6.1 (举例，防止和光猫冲突)
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 2. 修改主机名
sed -i 's/ImmortalWrt/Redmi-AX6/g' package/base-files/files/bin/config_generate

# 3. 针对 ImmortalWrt 的特定修正 (如果有)

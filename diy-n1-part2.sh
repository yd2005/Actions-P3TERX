#!/bin/bash
# N1 专用设置

# 1. N1 做旁路由，通常我们不在这里定死 IP，而是刷机后在后台改。
# 或者你可以预设一个不冲突的 IP，比如 192.168.6.2
sed -i 's/192.168.1.1/192.168.6.2/g' package/base-files/files/bin/config_generate

# 2. 修改主机名
sed -i 's/ImmortalWrt/Phicomm-N1/g' package/base-files/files/bin/config_generate

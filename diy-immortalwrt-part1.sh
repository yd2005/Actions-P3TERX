#!/bin/bash
# 这是专门给 AX6/N1 (ImmortalWrt) 用的源配置

# 添加 kenzok8 的 small 源 (包含最新的 sing-box, naiveproxy 等)
sed -i '1i src-git small https://github.com/kenzok8/small' feeds.conf.default

# 如果你原来的固件是 Lede，而现在 AX6 用 ImmortalWrt，
# 不要在这里写 git clone 切换源码的命令，我们会在 yml 环境变量里直接指定。

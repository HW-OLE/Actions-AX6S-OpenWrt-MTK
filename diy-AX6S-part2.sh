#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 替换luci-app-ttyd相关
rm -rf feeds/luci/applications/luci-app-ttyd
git clone https://github.com/openwrt/luci.git luci-repo
cp -r luci-repo/applications/luci-app-ttyd feeds/luci/applications/luci-app-ttyd
rm -rf luci-repo

# 替换luci-app-passwall相关
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall.git passwall-repo
cp -r passwall-repo/luci-app-passwall feeds/luci/applications/luci-app-passwall
rm -rf passwall-repo
rm -rf feeds/packages/net/haproxy
git clone https://github.com/immortalwrt/packages.git immortal-packages
cp -r immortal-packages/net/haproxy feeds/packages/net/haproxy
rm -rf immortal-packages
rm -rf feeds/packages/net/brook
rm -rf feeds/packages/net/trojan-go
rm -rf feeds/packages/net/trojan-plus

# 克隆 coolsnowwolf 的 luci 和 packages 仓库
git clone https://github.com/coolsnowwolf/luci.git coolsnowwolf-luci
git clone https://github.com/coolsnowwolf/packages.git coolsnowwolf-packages

# 替换luci-app-zerotier和luci-app-frpc
rm -rf feeds/luci/applications/{luci-app-zerotier,luci-app-frpc}
cp -r coolsnowwolf-luci/applications/{luci-app-zerotier,luci-app-frpc} feeds/luci/applications

# 替换zerotier、frp 和kcptun
rm -rf feeds/packages/net/{zerotier,frp,kcptun}
cp -r coolsnowwolf-packages/net/{zerotier,frp,kcptun} feeds/packages/net

# 添加 Golang 软件包
rm -rf feeds/packages/lang/golang
cp -r coolsnowwolf-packages/lang/golang feeds/packages/lang/golang

# 添加luci-app-adguardhome
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
rm -rf feeds/packages/net/adguardhome
cp -r coolsnowwolf-packages/net/adguardhome feeds/packages/net/adguardhome

# 删除克隆的 coolsnowwolf-luci 和 coolsnowwolf-packages 仓库
rm -rf coolsnowwolf-luci
rm -rf coolsnowwolf-packages

# 克隆 helloworld 仓库
git clone https://github.com/fw876/helloworld.git

# 替换 helloworld 系列软件包
PACKAGES="chinadns-ng dns2socks dns2tcp hysteria ipt2socks microsocks redsocks2 shadowsocks-rust shadowsocksr-libev simple-obfs tcping trojan v2ray-core v2ray-geodata v2ray-plugin v2raya xray-core xray-plugin shadow-tls mosdns"
for pkg in $PACKAGES; do
    rm -rf feeds/packages/net/$pkg
    cp -r helloworld/$pkg feeds/packages/net/$pkg
done

rm -rf feeds/luci/applications/luci-app-ssr-plus
cp -r helloworld/luci-app-ssr-plus feeds/luci/applications/luci-app-ssr-plus

# 替换 naiveproxy
git clone -b v5 https://github.com/sbwml/openwrt_helloworld.git
rm -rf feeds/packages/net/naiveproxy
cp -r openwrt_helloworld/naiveproxy feeds/packages/net
rm -rf openwrt_helloworld

# 删除克隆的 helloworld 仓库
rm -rf helloworld

git clone https://github.com/201821143044/openwrt-upx.git package/openwrt-upx

# 添加helloworld源
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld https://github.com/fw876/helloworld.git;master" >> "feeds.conf.default"
./scripts/feeds update helloworld
./scripts/feeds install -a -f -p helloworld

# 添加passwall packages源
echo "src-git PWpackages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
./scripts/feeds update PWpackages
./scripts/feeds install -a -f -p PWpackages

# 替换默认IP
sed -i 's#192.168.1.1#192.168.0.1#g' package/base-files/files/bin/config_generate

# 添加aliyundrive-webdav
git clone https://github.com/messense/aliyundrive-webdav.git messense-aliyundrive-webdav
cp -r messense-aliyundrive-webdav/openwrt/aliyundrive-webdav package/aliyundrive-webdav
cp -r messense-aliyundrive-webdav/openwrt/luci-app-aliyundrive-webdav package/luci-app-aliyundrive-webdav
rm -rf messense-aliyundrive-webdav

# 添加luci-app-openclash
git clone https://github.com/vernesong/OpenClash.git
cp -r OpenClash/luci-app-openclash package/luci-app-openclash
rm -rf OpenClash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

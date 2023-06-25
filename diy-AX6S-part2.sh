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
svn co https://github.com/openwrt/luci/trunk/applications/luci-app-ttyd feeds/luci/applications/luci-app-ttyd

# 替换luci-app-passwall相关
rm -rf feeds/luci/applications/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/haproxy
svn co https://github.com/immortalwrt/packages/trunk/net/haproxy feeds/packages/net/haproxy
rm -rf feeds/packages/net/brook
rm -rf feeds/packages/net/trojan-go
rm -rf feeds/packages/net/trojan-plus

# 替换luci-app-zerotier相关
rm -rf feeds/luci/applications/luci-app-zerotier
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
# git clone --depth=1 https://github.com/zhengmz/luci-app-zerotier.git feeds/luci/applications/luci-app-zerotier
rm -rf feeds/packages/net/zerotier
svn co https://github.com/coolsnowwolf/packages/trunk/net/zerotier feeds/packages/net/zerotier

# 替换luci-app-ssr-plus相关
rm -rf feeds/luci/applications/luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/packages/net/chinadns-ng
svn co https://github.com/fw876/helloworld/trunk/chinadns-ng feeds/packages/net/chinadns-ng
rm -rf feeds/packages/net/dns2socks
svn co https://github.com/fw876/helloworld/trunk/dns2socks feeds/packages/net/dns2socks
rm -rf feeds/packages/net/dns2tcp
svn co https://github.com/fw876/helloworld/trunk/dns2tcp feeds/packages/net/dns2tcp
rm -rf feeds/packages/net/hysteria
svn co https://github.com/fw876/helloworld/trunk/hysteria feeds/packages/net/hysteria
rm -rf feeds/packages/net/ipt2socks
svn co https://github.com/fw876/helloworld/trunk/ipt2socks feeds/packages/net/ipt2socks
rm -rf feeds/packages/net/microsocks
svn co https://github.com/fw876/helloworld/trunk/microsocks feeds/packages/net/microsocks
rm -rf feeds/packages/net/naiveproxy
svn co https://github.com/fw876/helloworld/trunk/naiveproxy feeds/packages/net/naiveproxy
rm -rf feeds/packages/net/redsocks2
svn co https://github.com/fw876/helloworld/trunk/redsocks2 feeds/packages/net/redsocks2
rm -rf feeds/packages/net/shadowsocks-rust
svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust feeds/packages/net/shadowsocks-rust
rm -rf feeds/packages/net/shadowsocksr-libev
svn co https://github.com/fw876/helloworld/trunk/shadowsocksr-libev feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/simple-obfs
svn co https://github.com/fw876/helloworld/trunk/simple-obfs feeds/packages/net/simple-obfs
rm -rf feeds/packages/net/tcping
svn co https://github.com/fw876/helloworld/trunk/tcping feeds/packages/net/tcping
rm -rf feeds/packages/net/trojan
svn co https://github.com/fw876/helloworld/trunk/trojan feeds/packages/net/trojan
rm -rf feeds/packages/net/v2ray-core
svn co https://github.com/fw876/helloworld/trunk/v2ray-core feeds/packages/net/v2ray-core
rm -rf feeds/packages/net/v2ray-geodata
svn co https://github.com/fw876/helloworld/trunk/v2ray-geodata feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/v2ray-plugin
svn co https://github.com/fw876/helloworld/trunk/v2ray-plugin feeds/packages/net/v2ray-plugin
rm -rf feeds/packages/net/v2raya
svn co https://github.com/fw876/helloworld/trunk/v2raya feeds/packages/net/v2raya
rm -rf feeds/packages/net/xray-core
svn co https://github.com/fw876/helloworld/trunk/xray-core feeds/packages/net/xray-core
rm -rf feeds/packages/net/xray-plugin
svn co https://github.com/fw876/helloworld/trunk/xray-plugin feeds/packages/net/xray-plugin
rm -rf feeds/packages/net/kcptun
svn co https://github.com/coolsnowwolf/packages/trunk/net/kcptun feeds/packages/net/kcptun

# 替换luci-app-frpc相关
rm -rf feeds/luci/applications/luci-app-frpc
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-frpc feeds/luci/applications/luci-app-frpc
rm -rf feeds/packages/net/frp
svn co https://github.com/coolsnowwolf/packages/trunk/net/frp feeds/packages/net/frp

git clone https://github.com/201821143044/openwrt-upx.git package/openwrt-upx

# 添加helloworld源
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"
./scripts/feeds update helloworld
./scripts/feeds install -a -f -p helloworld

# 添加passwall packages源
echo "src-git PWpackages https://github.com/xiaorouji/openwrt-passwall.git;packages" >> "feeds.conf.default"
./scripts/feeds update PWpackages
./scripts/feeds install -a -f -p PWpackages

# 替换默认IP
sed -i 's#192.168.1.1#192.168.0.1#g' package/base-files/files/bin/config_generate

# 添加Golang软件包
rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

# 添加aliyundrive-webdav
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav packages/aliyundrive-webdav
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav packages/luci-app-aliyundrive-webdav

# 添加luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# 添加额外软件包
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
rm -rf feeds/packages/net/adguardhome
svn co https://github.com/coolsnowwolf/packages/trunk/net/adguardhome feeds/packages/net/adguardhome

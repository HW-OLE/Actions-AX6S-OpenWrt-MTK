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
# 添加软件源
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"
echo "helloworld完毕"
./scripts/feeds update helloworld
./scripts/feeds install -a -f -p helloworld
echo "src-git luci2 https://github.com/coolsnowwolf/luci" >> "feeds.conf.default"
./scripts/feeds update luci2
./scripts/feeds install -a -f -p luci2
echo "src-git packages2 https://github.com/coolsnowwolf/packages" >> "feeds.conf.default"
./scripts/feeds update packages2
./scripts/feeds install -a -f -p packages2
echo "src-git PWpackages https://github.com/xiaorouji/openwrt-passwall.git;packages" >> "feeds.conf.default"
./scripts/feeds update PWpackages
./scripts/feeds install -a -f -p PWpackages
echo "src-git PWluci https://github.com/xiaorouji/openwrt-passwall.git;luci" >> "feeds.conf.default"
./scripts/feeds update PWluci
./scripts/feeds install -a -f -p PWluci

# 替换默认IP
sed -i 's#192.168.1.1#192.168.0.1#g' package/base-files/files/bin/config_generate

# 添加Golang软件包
rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

# 替换luci-app-aliyundrive-webdav相关
rm -rf feeds/luci2/applications/luci-app-aliyundrive-webdav
rm -rf feeds/packages2/multimedia/aliyundrive-webdav
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav feeds/luci2/applications/luci-app-aliyundrive-webdav
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav package/aliyundrive-webdav

# 添加luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

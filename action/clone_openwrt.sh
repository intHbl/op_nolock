#!/bin/bash

      #working-directory: /workdir
(
    cd  /workdir
    df -hT $PWD
  
    REPO_URL="https://github.com/openwrt/openwrt"
    REPO_BRANCH="openwrt-21.02"

    b="$REPO_BRANCH"
    #b="v21.02.5"
    # git clone --single-branch -b $REPO_BRANCH $REPO_URL  openwrt
    git clone --single-branch -b $b $REPO_URL  openwrt
    ln -sf /workdir/openwrt $GITHUB_WORKSPACE/openwrt
)

(
    # make u-boot partition readable
    ## openwrt/target/linux/ramips/dtsmt7621_xiaomi_mi-router-4a-3g-v2.dtsi
    src="$GITHUB_WORKSPACE/action/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi"
    dst="$GITHUB_WORKSPACE/openwrt/target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi"
    cp "$src" "$dst"
)


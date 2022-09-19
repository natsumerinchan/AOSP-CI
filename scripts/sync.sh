#!/bin/bash
#
mkdir ~/bin
PATH=~/bin:$PATH

# Source Vars

export REPO=https://github.com/Evolution-X/manifest
export DEVICE=fajita
export TYPE=eng
export AOSP=evolution
export BRANCH=tiramisu
export FALLBACK=snow


cd ~
wget https://github.com/snnbyyds/system_sepolicy/commit/fb5f19e95aca26485afba5a4082a41468e193098.patch
cat fb5f19e95aca26485afba5a4082a41468e193098.patch
wget https://github.com/snnbyyds/vendor_evolution/commit/f8aa0dfac15f5b8e784937cb2ad564fa5c300f1f.patch
cat f8aa0dfac15f5b8e784937cb2ad564fa5c300f1f.patch

curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

# FUCK H
rm -rf ~/android
mkdir ~/android
cd ~/android

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Clone the Sync Repo
cd ~/android
repo init -u https://github.com/Evolution-X/manifest -b tiramisu


# Sync the Sources
cd ~/android
echo '[DEBUG]repo sync -j6'
repo sync -j6

cd ~/android && pwd
cd system/sepolicy
git apply ~/fb5f19e95aca26485afba5a4082a41468e193098.patch
cd ~/android/vendor/evolution
git apply ~/f8aa0dfac15f5b8e784937cb2ad564fa5c300f1f.patch
cd ~/android

# Clone Device Specific(fallback)
rm -rf device/oneplus/fajita
git clone -b snow https://github.com/Evolution-X-Devices/device_oneplus_fajita.git device/oneplus/fajita
ls device/oneplus/fajita
rm -rf device/oneplus/sdm845-common
git clone -b lineage-19.1 https://github.com/snnbyyds/android_device_oneplus_sdm845-common.git device/oneplus/sdm845-common
ls device/oneplus/sdm845-common

# Clone the Kernel Sources(fallback)
git clone --depth=1 -b lineage-19.1 https://github.com/snnbyyds/android_kernel_oneplus_sdm845.git kernel/oneplus/sdm845

cd ~
wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/ee5ad7f5229892ff06b476e5b5a11ca1f39bf3a9/clang-r365631c.tar.gz
mkdir ~/android/prebuilts/clang/host/linux-x86/clang-r365631c
cd ~/android/prebuilts/clang/host/linux-x86/clang-r365631c && tar -xpvf ~/clang-r365631c.tar.gz && ls -l

cd ~/android
# Additional(fallback)

git clone -b lineage-20 https://github.com/LineageOS/android_hardware_oneplus.git hardware/oneplus

exit 0

#!/bin/bash

mkdir ~/bin
PATH=~/bin:$PATH

cd ~
wget https://github.com/snnbyyds/system_sepolicy/commit/fb5f19e95aca26485afba5a4082a41468e193098.patch
cat fb5f19e95aca26485afba5a4082a41468e193098.patch

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
cd ~/android

# Clone Device Specific
rm -rf device/oneplus/fajita
git clone -b tiramisu https://github.com/snnbyyds/evolution_device_oneplus_fajita.git device/oneplus/fajita
ls device/oneplus/fajita
rm -rf device/oneplus/sdm845-common
git clone -b lineage-19.1 https://github.com/snnbyyds/android_device_oneplus_sdm845-common.git device/oneplus/sdm845-common
ls device/oneplus/sdm845-common

# Clone the Kernel Sources
git clone --depth=1 -b snow https://github.com/snnbyyds/kernel_oneplus_sdm845.git kernel/oneplus/sdm845

cd ~/android
# Additional
git clone -b lineage-20 https://github.com/snnbyyds/android_hardware_oneplus.git hardware/oneplus
git clone --depth=1 https://github.com/snnbyyds/prebuilts_clang_host_linux-x86_clang-r383902.git prebuilts/clang/host/linux-x86/clang-r383902

exit 0

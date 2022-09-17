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

# Change to the Home Directory
cd ~

#wget https://github.com/snnbyyds/vendor_evolution/commit/78cbaec30a19516833b85ca71af7b9f9b289b444.patch
#cat 78cbaec30a19516833b85ca71af7b9f9b289b444.patch
wget https://github.com/snnbyyds/system_sepolicy/commit/fb5f19e95aca26485afba5a4082a41468e193098.patch
cat fb5f19e95aca26485afba5a4082a41468e193098.patch
# repo!
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
cd vendor/evolution
#git apply ~/78cbaec30a19516833b85ca71af7b9f9b289b444.patch
cd ~/android
cd system/sepolicy
git apply ~/fb5f19e95aca26485afba5a4082a41468e193098.patch
cd ~/android
# Clone Device Specific(fallback)
rm -rf device/oneplus/fajita
git clone -b snow https://github.com/Evolution-X-Devices/device_oneplus_fajita.git device/oneplus/fajita
ls device/oneplus/fajita
rm -rf device/oneplus/sdm845-common
git clone -b lineage-19.1 https://github.com/snnbyyds/android_device_oneplus_sdm845-common.git device/oneplus/sdm845-common
ls device/oneplus/sdm845-common

# Clone the Kernel Sources(fallback)
git clone --depth=1 -b lineage-20 https://github.com/Linux-Mobile/android_kernel_oneplus_sdm845.git kernel/oneplus/sdm845


git clone https://github.com/radcolor/aarch64-elf.git prebuilts/gcc/linux-x86/aarch64/aarch64-elf
#wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/12.2.mpacbti-bet1/binrel/arm-gnu-toolchain-12.2.mpacbti-bet1-x86_64-arm-none-eabi.tar.xz
cd ~
wget https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/+archive/refs/heads/idea133-weekly-release.tar.gz
cd ~/android
mkdir prebuilts/gcc/linux-x86/arm/arm-eabi
cd prebuilts/gcc/linux-x86/arm/arm-eabi
tar -xpvf ~/idea133-weekly-release.tar.gz
cd ~/android
# Additional(fallback)

git clone -b lineage-20 https://github.com/LineageOS/android_hardware_oneplus.git hardware/oneplus

# Additional
#git clone -b $BRANCH https://github.com/Evolution-X-Devices/vendor_oneplus.git vendor/oneplus


# Exit
exit 0

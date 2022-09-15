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

# FUCK BIGFOOTACA
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
#git clone --depth=1 -b lineage-20.0 https://github.com/EdwinMoq/android_kernel_oneplus_sdm845.git kernel/oneplus/sdm845
#git clone -b ElementalX-6.00 https://github.com/flar2/OnePlus6.git kernel/oneplus/sdm845
#git clone https://github.com/CherishOS-Devices/kernel_oneplus_sdm845.git kernel/oneplus/sdm845
#git clone -b oos11 https://github.com/ppajda/android_kernel_oneplus_sdm845.git kernel/oneplus/sdm845
#git clone -b 12.1 https://github.com/snnbyyds/platform_kernel_oneplus_sdm845.git kernel/oneplus/sdm845
#git clone -b nethunter-11.0 https://github.com/snnbyyds/nethunter_kernel_oneplus_sdm845-3.git kernel/oneplus/sdm845
#git clone -b snow https://github.com/Evolution-X-Devices/kernel_oneplus_sdm845.git kernel/oneplus/sdm845
#git clone -b lineage-19.1 https://github.com/snnbyyds/android_kernel_oneplus_sdm845.git ~/android_kernel_oneplus_sdm845
git clone -b 12 https://github.com/Havoc-fajita/a12kernel_oneplus_sdm845.git kernel/oneplus/sdm845
mv kernel/oneplus/sdm845/arch/arm64/configs/primus_defconfig kernel/oneplus/sdm845/arch/arm64/configs/enchilada_defconfig
# Additional(fallback)

git clone -b lineage-19.1 https://github.com/snnbyyds/android_hardware_oneplus.git hardware/oneplus

# Additional
#git clone -b $BRANCH https://github.com/Evolution-X-Devices/vendor_oneplus.git vendor/oneplus


# Exit
exit 0

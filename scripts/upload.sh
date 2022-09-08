#!/bin/bash

# Source Vars
# source $CONFIG
export REPO=https://github.com/Evolution-X/manifest
export DEVICE=fajita
export TYPE=userdebug
export AOSP=evolution
export BRANCH=tiramisu
export FALLBACK=snow

export USE_CCACHE=1
export CCACHE_SIZE=50G
#export ALLOW_MISSING_DEPENDENCIES=true
# export LC_ALL="C"
##########################

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Change to the Source Directory
cd ~/android
# Color
ORANGE='\033[0;33m'

# Display a message
echo "============================"
echo "Uploading the Build..."
echo "============================"

# Change to the Output Directory
cd out/target/product/${DEVICE}

# Set FILENAME var
ls evolution_fajita*.zip > FILENAME.txt
FILENAME=$(cat FILENAME.txt)
cat FILENAME.txt
# Upload to oshi.at
if [ -z "$TIMEOUT" ];then
    TIMEOUT=20160
fi

# Upload to WeTransfer
# NOTE: the current Docker Image, "registry.gitlab.com/sushrut1101/docker:latest", includes the 'transfer' binary by Default
transfer wet *.zip > link.txt || { echo "ERROR: Failed to Upload the Build!" && exit 1; }

# Mirror to oshi.at
curl -T $FILENAME https://oshi.at/${FILENAME}/${OUTPUT} > mirror.txt || { echo "WARNING: Failed to Mirror the Build!"; }

DL_LINK=$(cat link.txt | grep Download | cut -d\  -f3)
MIRROR_LINK=$(cat mirror.txt | grep Download | cut -d\  -f1)

# Show the Download Link
echo "=============================================="
echo "Download Link: ${DL_LINK}" || { echo "ERROR: Failed to Upload the Build!"; }
echo "Mirror: ${MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "=============================================="

DATE_L=$(date +%d\ %B\ %Y)
DATE_S=$(date +"%T")

# Send the Message on Telegram
echo -e \
"
🛠️ CI|  OrangeFox Recovery

Build Completed Successfully!

Device: "${DEVICE}"

" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "$TG_TEXT"

echo " "

# Exit
exit 0

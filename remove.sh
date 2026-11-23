#!/bin/sh

echo "------------------------------"
echo "Uninstall Sentinel One"
echo "------------------------------"

if [[ ! -d "/Volumes/macOS Base System" ]]; then
	echo "needs to be run from Recovery environment"
	exit -1
fi

if [[ $(ls /Volumes/Data/Library/LaunchAgents/com.sentinelone.*) ]]; then
	volume=/Volumes/Data
elif [[ $(ls /Volumes/SYSTEM/Library/LaunchAgents/com.sentinelone.*) ]]; then
	volume=/Volumes/SYSTEM
else
	echo "S1 not found"
	exit -1
fi

echo "deleting from $volume:"

rm -rf $volume/Library/LaunchAgents/com.sentinelone.*
rm -rf $volume/Library/LaunchDaemons/com.sentinelone.*
rm -rf $volume/Library/Preferences/Logging/Subsystems/com.sentinelone.*
rm -rf $volume/Library/Extensions/Sentinel.kext
rm -rf $volume/Library/Sentinel
rm -rf $volume/Applications/SentinelOne

for name in $volume/Library/SystemExtensions/* ; do
	if [[ -d "${name}/com.sentinelone.network-monitoring.systemextension" ]]; then
		rm -rf "$name"
	fi
done

echo "done."

exit 0

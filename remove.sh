#!/bin/sh

echo "------------------------------"
echo "Uninstall Sentinel One 1.6"
echo "------------------------------"

function handleVolume
{
	local volume="$1"

	echo "checking ${volume}"
	if [[ ! -f /Volumes/"$volume"/Library/LaunchAgents/com.sentinelone.agent.plist ]]; then
		return
	fi

	echo "** S1 found, deleting... **"

	rm -rf /Volumes/"$volume"/Library/LaunchAgents/com.sentinelone.*
	rm -rf /Volumes/"$volume"/Library/LaunchDaemons/com.sentinelone.*
	rm -rf /Volumes/"$volume"/Library/Preferences/Logging/Subsystems/com.sentinelone.*
	rm -rf /Volumes/"$volume"/Library/Extensions/Sentinel.kext
	rm -rf /Volumes/"$volume"/Library/Sentinel
	rm -rf /Volumes/"$volume"/Applications/SentinelOne

	for name in /Volumes/"$volume"/Library/SystemExtensions/* ; do
		if [[ -d "$name"/com.sentinelone.network-monitoring.systemextension ]]; then
			rm -rf "$name"
		fi
	done
}

if [[ ! -d "/Volumes/macOS Base System" ]]; then
	echo "needs to be run from Recovery environment"
	exit -1
fi

diskutil list -plist > /tmp/disks.plist
volumes=$(defaults read /tmp/disks.plist VolumesFromDisks  | sed 's/^ *//' | sed 's/,$//' | grep -v '^(' | grep -v '^)')
rm /tmp/disks.plist
IFS=$'\n'
for volume in $volumes; do
	handleVolume "$volume"
done

echo "done."

exit 0

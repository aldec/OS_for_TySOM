#!/bin/bash

DEVICE=`ls /sys/devices/platform/amba_pl@0/ | grep v_mix`
/usr/bin/modetest -D ${DEVICE} >> /dev/null

device_status=`ls -1 /sys/class/drm/card*/status`
device=0
hdmi=0
for file in $device_status
do
	if [ $(cat ${file} 2>/dev/null) = "connected" ]; then
		if [[ $file =~ (card)([0-9]) ]]; then 
			device=${BASH_REMATCH[2]}
		fi 
		if [[ $file =~ (HDMI) ]]; then
			if [ "${BASH_REMATCH[1]}" = "HDMI" ]; then
				hdmi=1
			fi
		fi
	fi
done

if [ ${hdmi} -eq 1 ]; then
	if [ ! $DEVICE = "" ]; then
		RESOLUTION=`modetest -D ${DEVICE} | grep preferred -m 1 | cut -d ' ' -f3`
		/usr/bin/timeout 0.5 /usr/bin/modetest -D ${DEVICE} -s 36@34:${RESOLUTION}@AR24 -v >> /dev/null
	fi
fi

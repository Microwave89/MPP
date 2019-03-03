#!/system/bin/sh
FLYDAT_CLEANUP_LOG=/data/dji/log/custom_log.txt
GND_IP_ADDR=192.168.41.2

busybox ping -c 1 -w $(($((1 << 31)) - 1)) $GND_IP_ADDR>>$FLYDAT_CLEANUP_LOG

while :
do
	sleep 0.1
	# Redirect stderr (2) to /dev/null to prevent "LOG: write failed" messages clogging stdout
	logcat 2>/dev/null | grep -FEm 1 ', 0, 1, 0, 1, 0, 0, ., 1, 0, 0, ., 0, 0, 0, ..'>>$FLYDAT_CLEANUP_LOG
	echo "\"Pause\" + \"C2\" buttons pressed ==> Removing all FLYnnn.DAT!">>$FLYDAT_CLEANUP_LOG
	rm -rf 2>>$FLYDAT_CLEANUP_LOG /blackbox/flyctrl/

	echo "Waiting for button release...">>$FLYDAT_CLEANUP_LOG

	logcat 2>/dev/null | grep -FEm 1 ', 0, 0, 0, 0, 0, 0, ., 1, 0, 0, ., 0, 0, 0, ..'>>$FLYDAT_CLEANUP_LOG
	echo "Buttons released!">>$FLYDAT_CLEANUP_LOG
done

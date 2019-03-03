#!/system/bin/sh
GND_IP_ADDR=192.168.41.2
SDR_POWER_LOG=/data/dji/log/custom_log.txt

busybox ping -c 1 -w $(($((1 << 31)) - 1)) $GND_IP_ADDR>>$SDR_POWER_LOG

while :
do
	sleep 0.1
	# Redirect stderr (2) to /dev/null to prevent "LOG: write failed" messages clogging stdout
	logcat 2>/dev/null | grep -FEm 1 ', 0, 1, 1, 1, 0, 0, ., 1, 0, 0, ., 0, 0, 0, ..'>>$SDR_POWER_LOG
	echo "\"Pause\" + \"C1\" + \"C2\" buttons pressed ==> Setting SDR power to \"FCC\"!">>$SDR_POWER_LOG
	dji_mb_ctrl -S test -R local -g 9 -s 9 -c 27 00024800FFFF0200000000>>$SDR_POWER_LOG
	echo "Waiting for button release...">>$SDR_POWER_LOG

	logcat 2>/dev/null | grep -FEm 1 ', 0, 0, 0, 0, 0, 0, ., 1, 0, 0, ., 0, 0, 0, ..'>>$SDR_POWER_LOG
	echo "Buttons released!">>$SDR_POWER_LOG

	logcat 2>/dev/null | grep -FEm 1 ', 0, 1, 1, 1, 0, 0, ., 1, 0, 0, ., 0, 0, 0, ..'>>$SDR_POWER_LOG
	echo "\"Pause\" + \"C1\" + \"C2\" buttons pressed ==> Setting SDR power to default!">>$SDR_POWER_LOG
	dji_mb_ctrl -S test -R local -g 9 -s 9 -c 27>>$SDR_POWER_LOG
	echo "Waiting for button release...">>$SDR_POWER_LOG

	logcat 2>/dev/null | grep -FEm 1 ', 0, 0, 0, 0, 0, 0, ., 1, 0, 0, ., 0, 0, 0, ..'>>$SDR_POWER_LOG
	echo "Buttons released!">>$SDR_POWER_LOG
done

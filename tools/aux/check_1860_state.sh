#!/system/bin/sh
# Root access
if [ ! -f /tmp/dji/secure_debug ]; then
        /system/bin/adb_en.sh NonSecurePrivilege
fi

# Run original file
/system/bin/check_1860_state.sh&

# Hook for custom upgrades 
mount -o bind /vendor/bin/dummy_verify.sh /sbin/dji_verify

# Extended custom functions for RC buttons
/vendor/bin/manage_sdr_power.sh&
/vendor/bin/manage_flydat_cleanup.sh&

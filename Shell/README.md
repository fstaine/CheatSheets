# Shell

### List installed packages
```bash
dpkg -l
```

### Search package
```bash
apt-cache search XXX
```

### List used ports
Options:
 * `-t` TCP ports
 * `-u` UDP ports
```bash
netstat -t --listening
```
### Put job in foreground

Show jobs in background
```bash
jobs
```

Put a job in foreground
```bash
fg <ID>
```

# ZSH

### Add global path to $PATH
Add Path to `/etc/zsh/zshenv`

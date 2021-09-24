# Shell

### List installed packages
```bash
dpkg -l
```

### List used ports
Options:
 * `-t` TCP ports
 * `-u` UDP ports
```bash
netstat -t --listening
```
### Pub job in foreground

Show jobs in background
```bash
jobs
```

Put a job in foreground
```bash
fg <ID>
```

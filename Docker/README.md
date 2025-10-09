# Docker

### Docker Security Cheat sheet
[Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)

### Connect to a container
```bash
docker ps
docker exec -it <mycontainer> bash
```

### Get an intermediary container ID:

```
DOCKER_BUILDKIT=0 docker build...
```

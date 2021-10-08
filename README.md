# suse-docker-saltclient

# Checkout
```
git clone ...
cd suse-docker-saltclient
```

# Build
```
podman build -t salttest .
```

# Run
```
for i in $(seq 1 10); do podman run -d --name saltclient${i} salttest; done
```


# suse-docker-saltclient

# Checkout
```
git clone ...
cd suse-docker-saltclient
```

# Build
```
docker build -t salttest:123 .
```

# Run
```
for i in $(seq 1 10); do docker run -d --name saltclient${i} salttest:123; done
```


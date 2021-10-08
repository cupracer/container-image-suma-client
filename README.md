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

(remember to adjust the variables)

## a single instance
```
podman run -d --restart on-failure -e ACTIVATION_KEY=1-mykey -e SUMA_HOSTNAME=suma.example.com
```

## a whole bunch
```
for i in $(seq 1 10); 
do 
	podman run -d --restart on-failure -e ACTIVATION_KEY=1-mykey -e SUMA_HOSTNAME=suma.example.com --name saltclient${i} saltclient
done
```

# Hints

## Let Salt automatically accept new keys
```
echo "auto_accept: True" > /etc/salt/master.d/custom.conf
systemctl restart salt-master.service
```

## Simulate a system with missing updates
Visit https://registry.suse.com/static/suse/sle15sp3/index.html and pick an image tag with an older date.
Use this tag in Dockerfile as base image or use:
```
podman build -f Dockerfile-15.3.13.18 -t saltclient:15.3.13.18 .
```


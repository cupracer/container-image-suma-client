# suse-docker-saltclient

# Checkout
```
git clone ...
cd suse-docker-saltclient
```

# Preparations on SUSE Manager

Create custom bootstrap script (Don't replace the variables - we need the string as-is!).
```
mgr-bootstrap \
	--activation-keys='${ACTIVATION_KEY}' \
	--hostname='${SUMA_HOSTNAME}' \
	--allow-config-actions \
	--allow-remote-commands \
	--script=bootstrap-podman.sh \
	--force
```

# Build
```
podman build -t salttest .
```

# Run

(remember to adjust the variables)

## a single instance
```
podman run -d --restart always -e ACTIVATION_KEY=1-mykey -e SUMA_HOSTNAME=suma.example.com saltclient
```

## a whole bunch
```
for i in $(seq 1 10); 
do 
	podman run -d --restart always -e ACTIVATION_KEY=1-mykey -e SUMA_HOSTNAME=suma.example.com --name saltclient${i} saltclient
done
```

# Hints

## Let Salt on SUSE-Manager automatically accept new keys
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

## Use host's RMT server connection as package sources for image building
Retrieve RMT's CA certiciate and add it to your Dockerfile (right at the beginning):
```
COPY ./rmt-server.crt /etc/pki/trust/anchors/rmt-server.crt
RUN update-ca-certificates
```

## Adjust sysctl settings to run a whole lot of instances with Podman < 3.2.2 

see: 
- https://github.com/cri-o/ocicni/pull/92/commits/92f104c2fed3d15c416adde0908d4d82ba2083df
- https://fossies.org/linux/podman/RELEASE_NOTES.md

```
 # cat /etc/sysctl.d/99-podman.conf
fs.inotify.max_user_instances = 128001
fs.inotify.max_user_watches = 65536001
```


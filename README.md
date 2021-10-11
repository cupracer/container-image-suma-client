# container-image-suma-client

This repository contains the necessary components to create a minimal container image based on a SUSE Linux Enterprise Server (SLES) or openSUSE to be used to create lightweight test systems to connect to a SUSE Manager.

The container needs the name of an accessible SUSE Manager server and an activation key. It will download a special bootstrap script and then register against the SUSE Manager. If everything was successful, the running container is connected to the SUSE Manager via salt-minion and can basically be managed centrally.

**Please note:** A full Systemd environment is running in the container. I am aware that this procedure does not fit the usual microservice approach. However, the use-case described above aims at generating a large number of dummies in a resource-saving way in order to have a large systemd environment available for testing the SUSE Manager.

**Please note at least:** This project is not intended for production purposes.

# Requirements

* This project requires Podman to work correctly. Docker does not seem to have the capability to run containers with Systemd on PID 1.
* The host which runs Podman needs to be registered against SUSE Customer Center (SCC) or a local RMT server to be able to share its repository access (via "container-suseconnect-zypp") while building SLE-based images. See [here](#use-the-hosts-rmt-server-connection-to-retrieve-packages-for-image-building) to learn how to share and use your RMT's CA certificate during image building.

# Checkout

```
git clone ...
cd container-image-suma-client
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

If you need to adjust the `--script=` filename, please also adjust the environment variable `-e BOOTSTRAP_FILE=""` when running a container.

# Build

This repository contains a few different Dockerfiles. Pick one and copy it to `Dockerfile` and make adjustments as needed. You could as well skip this step, but you'd then need to specify the Dockerfile to be used with `-f` for `podman build`.

```
cp Dockerfile.sle15-sp3\:latest Dockerfile
podman build -t sumaclient .
```
or
```
podman build -f Dockerfile.sle15-sp3:latest -t sumaclient .
```

# Run

The images in this project are runnable without additional environment variables. The resulting containers will start Systemd and so to say boot. However, as this project aims at generating containers to be registered against a SUSE Manager, it's necessary to provide at least the environment variables `SUMA_HOSTNAME` and `ACTIVATION_KEY` to initialize the bootstrap process. Remember to adjust these variables accordingly.

The parameter `--name sumaclient1` is optional and just helps to identify the running container. It must be unique, of course.

The parameter `-h sumaclient1` is optional, too. It sets the container's internal hostname and helps to identify it within SUSE Manager. If it's not set, a hard-to-remember ID will be used instead.

## Run a single instance

```
podman run -d --restart always \
  -e ACTIVATION_KEY=1-mykey \
  -e SUMA_HOSTNAME=suma.example.com \
  --name sumaclient1 \
  -h sumaclient1 \
  sumaclient
```

## Run a whole bunch

```
for i in $(seq 1 10); 
do 
  podman run -d --restart always \
    -e ACTIVATION_KEY=1-mykey \
    -e SUMA_HOSTNAME=suma.example.com \
    --name sumaclient${i} \
    -h sumaclient${i} \
    sumaclient
done
```

# Hints

## Delay execution of bootstrap script

To reduce performance peaks when creating and registering multiple containers at once, the following environment variables can be used to delay the bootstrap script execution:

```
podman run ....
  -e MIN_DELAY_SEC=x -e MAX_DELAY_SEC=y
.....
```

This will chose a random number between `MIN_DELAY_SEC` and `MAX_DELAY_SEC` and will wait this value in seconds before starting the bootstrap script.
The default values of these variables are "0", so a delay is not used if not requested explicitly.

## Let salt-master on SUSE-Manager automatically accept new keys

If you prefer not to have to allow each new system individually in SUSE Manager you can customize the salt-master config as follows:

```
echo "auto_accept: True" > /etc/salt/master.d/custom.conf
systemctl restart salt-master.service
```

## Simulate a system with missing updates

Visit https://registry.suse.com/static/suse/sle15sp3/index.html and pick an image tag with an older date.
Use this tag in Dockerfile as base image or use:
```
podman build -f Dockerfile.sle15-sp3:15.3.13.18 -t sumaclient:15.3.13.18 .
```

## Use the host's RMT server connection to retrieve packages for image building

Retrieve the RMT's CA certificate and add it to your Dockerfile (right at the beginning):
```
COPY ./rmt-server.crt /etc/pki/trust/anchors/rmt-server.crt
RUN update-ca-certificates
```

## Adjust sysctl settings to run a whole lot of instances with Podman < 3.2.2 

see: 
- https://github.com/cri-o/ocicni/pull/92/commits/92f104c2fed3d15c416adde0908d4d82ba2083df
- https://fossies.org/linux/podman/RELEASE_NOTES.md

Create `/etc/sysctl.d/99-podman.conf` and increase the following options:
```
cat <<EOF > /etc/sysctl.d/99-podman.conf
fs.inotify.max_user_instances = 128000
fs.inotify.max_user_watches = 65536000
EOF
```

Load the adjusted values with:
```
sysctl -p --system
```

Please note that the above values were chosen very half-heartedly and randomly... but at least they worked for ~500 containers.


FROM registry.suse.com/suse/sle15:latest

#COPY ./some-ca.crt /etc/pki/trust/anchors/some-ca.crt
#RUN update-ca-certificates

RUN zypper -n ref && \
	zypper -n install \
	w3m \
	hostname \
	curl \
	wget \
	vim \
	awk \
	less \
	command-not-found \
	systemd-sysvinit

###

RUN zypper -n install dbus-1 gzip iproute2 kbd kbd-legacy kmod libapparmor1 libargon2-1 libcryptsetup12 libcryptsetup12-hmac libdbus-1-3 libdevmapper1_03 libjson-c3 libkmod2 libmnl0 libpgm-5_2-0 libqrencode4 libseccomp2 libsodium23 libunwind libxtables12 libzmq5 logrotate net-tools pam-config pkg-config python3-Babel  python3-Jinja2 python3-M2Crypto python3-MarkupSafe python3-PyYAML python3-appdirs python3-asn1crypto python3-certifi python3-cffi python3-chardet  python3-cryptography python3-distro python3-idna python3-msgpack python3-packaging python3-psutil python3-py python3-pyOpenSSL python3-pyasn1  python3-pycparser python3-pyparsing python3-pytz python3-pyzmq python3-requests python3-salt python3-setuptools python3-six python3-urllib3  python3-zypp-plugin salt salt-minion suse-module-tools system-group-kvm systemd systemd-default-settings systemd-default-settings-branding-SLE  systemd-presets-branding-SLE systemd-presets-common-SUSE timezone udev xz

####

COPY ./bootstrap.sh /usr/local/sbin/bootstrap.sh
COPY ./register.sh /usr/local/sbin/register.sh
COPY ./register.service /etc/systemd/system/register.service

RUN chmod +x /usr/local/sbin/bootstrap.sh /usr/local/sbin/register.sh

RUN systemctl enable register.service

ENV ACTIVATION_KEY="1-example-key"
ENV SUMA_HOSTNAME="suma.example.com"

CMD [ "/sbin/init" ]


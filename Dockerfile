FROM registry.suse.com/suse/sle15:latest

#COPY ./some-ca.crt /etc/pki/trust/anchors/some-ca.crt
#RUN update-ca-certificates

RUN zypper -n ref && \
	zypper -n install \
	awk \
	command-not-found \
	curl \
	hostname \
	less \
	systemd-sysvinit \
	vim \
	w3m \
	wget

COPY ./systemd-logind.service.d_override.conf /etc/systemd/system/systemd-logind.service.d/override.conf
COPY ./uptime-faker.service /etc/systemd/system/uptime-faker.service
COPY ./system-mods.service /etc/systemd/system/system-mods.service

COPY ./system-mods.sh /usr/local/sbin/system-mods.sh
COPY ./uptime.py /usr/local/sbin/uptime.py

RUN chmod +x \
	/usr/local/sbin/system-mods.sh \
	/usr/local/sbin/uptime.py

RUN systemctl enable \
	uptime-faker.service \
	system-mods.service

ENV ACTIVATION_KEY="1-example-key"
ENV SUMA_HOSTNAME="suma.example.com"

CMD [ "/sbin/init" ]


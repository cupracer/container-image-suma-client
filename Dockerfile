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

COPY ./systemd-logind.service.d_override.conf /etc/systemd/system/systemd-logind.service.d/override.conf
COPY ./system-faker.sh /usr/local/sbin/system-faker.sh
COPY ./system-faker.service /etc/systemd/system/system-faker.service
COPY ./uptime.py /usr/local/sbin/uptime.py

RUN chmod +x /usr/local/sbin/system-faker.sh /usr/local/sbin/uptime.py

RUN systemctl enable system-faker.service

ENV ACTIVATION_KEY="1-example-key"
ENV SUMA_HOSTNAME="suma.example.com"

CMD [ "/sbin/init" ]


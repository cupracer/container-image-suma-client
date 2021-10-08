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
COPY ./bootstrap.sh /usr/local/sbin/bootstrap.sh
COPY ./register.sh /usr/local/sbin/register.sh
COPY ./register.service /etc/systemd/system/register.service

RUN chmod +x /usr/local/sbin/bootstrap.sh /usr/local/sbin/register.sh

RUN systemctl enable register.service

ENV ACTIVATION_KEY="1-example-key"
ENV SUMA_HOSTNAME="suma.example.com"

CMD [ "/sbin/init" ]


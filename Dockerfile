FROM alpine:3.21.3

# Install necessary packages for remote SSH + zsh (optional)
RUN apk add --no-cache \
    gcompat=1.0.0-r0 \
    libstdc++=12.3.1_git20231212-r0 \
    curl=8.5.0-r0 \
    git=2.42.0-r0 \
    grep=3.11-r0 \
    dropbear=2022.83-r3 \
    dropbear-scp=2022.83-r3 \
    dropbear-ssh=2022.83-r3 \
    zsh=5.9-r3

# hadolint ignore=DL4006
RUN echo "root:root" | chpasswd

# Generate SSH keys (RSA only)
RUN dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key

# Expose SSH port
EXPOSE 22

# Start Dropbear in foreground (non-detached mode)
CMD ["/usr/sbin/dropbear", "-F", "-E", "-r", "/etc/dropbear/dropbear_rsa_host_key", "-p", "22"]

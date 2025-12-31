FROM caddy:2-alpine

LABEL org.opencontainers.image.source="https://github.com/LittleDrop/littledrop.cz"
LABEL org.opencontainers.image.description="Littledrop.cz website"

ENV TZ="Europe/Prague"
ENV TERM=xterm

COPY Caddyfile /etc/caddy/Caddyfile
COPY public/ /usr/share/caddy

HEALTHCHECK --interval=30s --timeout=1s \
	CMD nc -z 127.0.0.1 8080 || exit 1

EXPOSE 8080

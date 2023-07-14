# dev

development 💻 

This repository consists of files useful for local development.

## Quickstart

Just run:

```sh
docker compose up
```

## Accessing services

All services are exposed on the host machine with the respective ports,
so you can always access them on `localhost:{port}`.

But there is also another, more convenient way to access the services.
There is a `proxy` service that runs on port `80` and `443` and acts like a
reverse proxy. It will forward all requests to the respective service.
You can access the services by going to `{service}.{domain}`.

For example, if you set `domain` to `localhost` then you can access `emishows`
at `emishows.localhost`. By the way, `localhost` works without any additional
work, because browsers automatically resolve it to `127.0.0.1`.

However, by default [`traefik.me`](https://traefik.me) is used as the domain,
because it is a special domain that resolves to the prefixed IP address
(or `127.0.0.1` if not provided). This way you can access the services
from any device on the same network.

For example, if your computer IP address in LAN is `192.168.0.10`
and you want to access `emishows` then you can do it by:

- going to
  [`emishows.traefik.me`](https://emishows.traefik.me) 
  on your computer,
- going to 
  [`emishows-127-0-0-1.traefik.me`](https://emishows-127-0-0-1.traefik.me)
  on your computer,
- going to 
  [`emishows-192-168-0-10.traefik.me`](https://emishows-192-168-0-10.traefik.me)
  on any computer in LAN
  (for this one you need to use DNS server that is not too strict,
  like Google's [`8.8.8.8`](https://dns.google), but if it doesn't work,
  it's because your ISP is blocking DNS traffic to third-party DNS servers).

If you use `traefik.me` as the domain,
then TLS certificates are automatically loaded using the `certs` service,
and you can use HTTPS.
You can also use other domain services (like [`sslip.io`](https://sslip.io))
or your own domain,
but you will need to provide your own certificates to use TLS.

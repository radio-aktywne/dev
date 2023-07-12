# dev

development 💻 

This repository consists of files useful for local development.

## Quickstart

First go into the `docker` directory:

```sh
cd docker
```

Build all images with:

```sh
docker compose config --services | xargs -n1 docker compose build
```

This explicitly builds all images sequentially (only one at a time)
to avoid frequent network errors when building everything in parallel.
Be patient, it might take a while.

Then you can start the services with:

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

## Repository structure

All services have their own directory with submodule ref pointing to the service
repository.

`.yaml` files named after each service can be used for production on their own.
`docker-compose.yaml` can be used for local development as it aggregates all
services and builds them from local sources.

## Usage

There are two major ways to run the services:

- Running all services from local sources:

  ```sh
  cd docker && docker compose up
  ```

- Running all services from remote sources:

  ```sh
  cd docker && docker compose -f docker-compose.remote.yaml up
  ```

Note: Both ways should only be used for local development.

## Submodules

All our services have their own repositories, but for local development it's
sometimes easier to have everything in the same place. That's why we are using
submodules which points to specific commits in the services repositories. That
way you can make changes to the services in parallel and test if they work
together, while still keeping the services decoupled.

Keep in mind that the services should be treated separately. If the services
work together there probably always is a one-way relationship (like
client-server). If you change something in two services at the same time, think
of it as changing the rules of one side of the relationship and only then
adjusting the other side. You can't publish the changes at the same time on both
sides, but with version pinning in submodules that's not a problem. Just update
the submodule refs when changes on both sides are published, so that the state
is consistent all the time.

The typical workflow would be like this:

1. First you clone the repository:

    ```sh
    git clone --recursive git@github.com:radio-aktywne/reactor.git
    ```

   The `--recursive` option will clone the submodules too.

2. Some time passes. No changes on local were made, but upstream submodule refs
   changed, and you want to update your local repository (including submodules):

    ```sh
    git pull && git submodule update --init
    ```

   The upstream contains updated submodule refs. First the changes are pulled
   and then local submodules are updated to the specified refs. The `--init`
   options makes sure everything works in case when new submodules were added.

3. Some more time passes. This time nothing changed on upstream, but you made
   some commits in submodules and pushed them to their upstreams, and you want
   to update the refs in the upstream:

    ```sh
    git add . && git commit -m 'Updated submodule refs' && git push
    ```

   Submodule refs are represented as files, so you do it as usual.

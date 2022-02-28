# reactor

composefiles 🐋

This repository consists of composefiles for all our services ready for both
production and development.

## Quickstart

To run all services locally:

```sh
docker-compose up --build
```

## Repository structure

All services have their own directory with submodule ref pointing to the service
repository.

`.yml` files named after each service can be used for production on their own.
`docker-compose.yml` can be used for local development as it aggregates all
services and builds them from local sources.

## Usage

There are two major ways to run the services:

- Running all services from local sources:

  ```sh
  docker-compose up --build
  ```

- Running selected services (e.g. `streamcast`, `fusion`) from upstream images:

  ```sh
  docker-compose -f streamcast.yml -f fusion.yml up
  ```

Note: running from local sources should only be used for local development.

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

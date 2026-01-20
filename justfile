#!/usr/bin/env -S just --justfile

panel_compose := "panel/compose.yml"
wings_compose := "wings/compose.yml"
nginx_compose := "nginx/compose.yml"

list-recipes:
    @just --list

[group('setup')]
create-default-network:
    docker network create --driver bridge --opt com.docker.network.bridge.name=default0 --subnet 172.20.0.0/16 default_nw

[group('setup')]
remove-default-network:
    docker network rm default_nw

[group('setup')]
create-nginx-network:
    docker network create --driver bridge --opt com.docker.network.bridge.name=nginx0 --subnet 172.18.0.0/16 nginx_nw

[group('setup')]
remove-nginx-network:
    docker network rm nginx_nw

[group('setup')]
merge-wings-config:
    yq -i '. *= load("wings/config.override.yml")' wings/.ignore/config.yml

[group('lifecycle')]
panel action *OPTIONS:
    docker compose -f {{panel_compose}} {{action}} {{OPTIONS}}

[group('lifecycle')]
wings action *OPTIONS:
    docker compose -f {{wings_compose}} {{action}} {{OPTIONS}}

[group('lifecycle')]
nginx action *OPTIONS:
    docker compose -f {{nginx_compose}} {{action}} {{OPTIONS}}

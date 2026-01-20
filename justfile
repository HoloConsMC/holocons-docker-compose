#!/usr/bin/env -S just --justfile

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
    docker network create --driver bridge --opt com.docker.network.bridge.name=nginx0 --subnet 172.19.0.0/16 nginx_nw

[group('setup')]
remove-nginx-network:
    docker network rm nginx_nw

[group('setup')]
merge-wings-config:
    yq -i '. *= load("wings/config.override.yml")' /etc/pelican/config.yml

[group('lifecycle')]
compose name action *OPTIONS:
    docker compose -f {{ name }}/compose.yml {{ action }} {{ OPTIONS }}

[group('lifecycle')]
pull name:
    docker compose -f {{ name }}/compose.yml pull

[group('lifecycle')]
up name:
    docker compose -f {{ name }}/compose.yml up -d

[group('lifecycle')]
down name:
    docker compose -f {{ name }}/compose.yml down

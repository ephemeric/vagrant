#!/usr/bin/env bash

cd /vagrant/images/

for __image in *.xz; do
    docker image load -i "$__image"
done

exit 0

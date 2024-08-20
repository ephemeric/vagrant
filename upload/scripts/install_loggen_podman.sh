#!/usr/bin/env bash

set -ETeuo pipefail

podman build -t localhost/ephemeric/loggen:0.0.1 .

exit 0

#https://raw.githubusercontent.com/docker-library/python/1b7a1106674a21e699b155cbd53bf39387284cca/3.8/slim-bullseye/Dockerfile
#pip --version; \
#pip install pandas==2.0.3 geoip2==4.8.0 faker==25.2.0

#python 3.8.19
#aiohttp==3.9.5
#aiosignal==1.3.1
#async-timeout==4.0.3
#attrs==23.2.0
#certifi==2024.2.2
#charset-normalizer==3.3.2
#Faker==25.2.0
#frozenlist==1.4.1
#geoip2==4.8.0
#idna==3.7
#maxminddb==2.6.1
#multidict==6.0.5
#numpy==1.24.4
#pandas==2.0.3
#python-dateutil==2.9.0.post0
#pytz==2024.1
#requests==2.32.2
#six==1.16.0
#tzdata==2024.1
#urllib3==2.2.1
#yarl==1.9.4

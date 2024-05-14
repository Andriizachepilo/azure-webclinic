#!/bin/bash

docker build -t admin:taggg \
                 --build-arg JARPATH="services/admin-server/target/admin-server-3.2.4.jar" \
                 --build-arg PORT=8888 .
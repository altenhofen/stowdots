#!/bin/sh

mkdir -p ~/.local/share/nvim/mason/packages/lombok-nightly
curl -L https://projectlombok.org/downloads/lombok.jar --output ~/.local/share/nvim/mason/packages/lombok-nightly

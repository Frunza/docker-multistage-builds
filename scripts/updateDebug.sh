#!/bin/sh

# Exit immediately if a simple command exits with a nonzero exit value
set -e

echo "Cleaning up generated files..."
sh scripts/clean.sh

echo "Preparing build image..."
docker build -t terraformwithvolumetest -f docker/dockerfile --target config_only .

echo "Updating infrastructure..."
docker-compose -f docker/update-debug-docker-compose.yml run --rm main

echo "Done"

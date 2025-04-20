#!/bin/bash
docker buildx build --platform linux/amd64,linux/arm64 --push -t ahdpik849/rudzitest:1.0 .

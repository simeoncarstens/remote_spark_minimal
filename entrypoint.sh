#!/usr/bin/env bash

source .venv/bin/activate
source set_remote_cluster_env.sh
exec "$@"

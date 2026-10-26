#!/bin/bash
set -ex

chown -R 8983:8983 /var/solr

# Create the core if it doesn't exist, starts Solr in the foreground
solr-precreate collection /solr-conf &
SOLR_PID=$!

# Wait for Solr to be ready
until curl -sf http://localhost:8983/solr/collection/admin/ping; do sleep 2; done

# Always copy the latest schema
cp /solr-conf/managed-schema /var/solr/data/collection

# Reload the core to pick up schema changes
curl -sf "http://localhost:8983/solr/admin/cores?action=RELOAD&core=collection"

# Keep Solr running in the foreground
wait $SOLR_PID

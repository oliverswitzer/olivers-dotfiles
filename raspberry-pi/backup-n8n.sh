#!/bin/bash

# Get the container ID of the n8n container
CONTAINER_ID=$(sudo docker ps --filter "ancestor=docker.n8n.io/n8nio/n8n" --format "{{.ID}}")

# Check if we got the container ID
if [ -z "$CONTAINER_ID" ]; then
    echo "No n8n container found."
    exit 1
else
    echo "Found n8n container ID: $CONTAINER_ID"
fi

# Execute the command in the n8n container and filter out the unwanted line
sudo docker exec -it $CONTAINER_ID n8n export:workflow --all | sed '1d' > n8n-backup.json

echo "Export completed and saved to n8n-backup.json"


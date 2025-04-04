#!/bin/bash

API_KEY="INSER YOUR API KEY HERE"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
IMAGE_PATH="$SCRIPT_DIR/apod.jpg"

# Ensure the script can write in the directory
if [ ! -w "$SCRIPT_DIR" ]; then
    echo "Error: No write permission in $SCRIPT_DIR. Try running in a writable folder." >&2
    exit 1
fi

# Fetch APOD data
JSON_DATA=$(curl -s "https://api.nasa.gov/planetary/apod?api_key=$API_KEY")

# Extract image URL
MEDIA_URL=$(echo "$JSON_DATA" | jq -r '.hdurl // .url')

# Check if URL is an image
if [[ "$MEDIA_URL" == *youtube.com* || "$MEDIA_URL" == *vimeo.com* ]]; then
    exit 0
else
    IMAGE_URL="$MEDIA_URL"
    wget -q -O "$IMAGE_PATH" "$IMAGE_URL"
fi

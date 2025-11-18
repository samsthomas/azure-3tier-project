#!/bin/sh

echo "Starting entrypoint..."
echo "API_URL=${API_URL}"

sed -i "s|__API_URL__|${API_URL}|g" /usr/share/nginx/html/app.js || { echo "sed failed"; exit 1; }

echo "sed completed"

nginx -g "daemon off;"
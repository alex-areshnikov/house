#!/bin/bash
set -e

cd /house

# Run migrations
bundle exec rake db:migrate RAILS_ENV=production

# Run listener
bundle exec rake mqtt:listen_holodilnic_topic RAILS_ENV=production

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

while true; do sleep 1000; done

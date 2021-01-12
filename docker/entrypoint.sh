#!/bin/bash
set -e

cd /var/www/house

# Run migrations
bundle exec rake db:migrate RAILS_ENV=production

# Run listener
#bundle exec rake mqtt:listen_holodilnic_topic RAILS_ENV=production

# Then exec the container's main process (what's set as CMD in the Dockerfile).
#exec "$@"

# Run Rails
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails s -b 0.0.0.0 -e production

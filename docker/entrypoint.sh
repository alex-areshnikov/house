#!/bin/bash
set -e

cd /var/www/house

RAILS_ENV=production

# Run migrations
bundle exec rake db:migrate

# Run listener
#bundle exec rake mqtt:listen_holodilnic_topic RAILS_ENV=production

# Run Rails
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails assets:clean
bundle exec rails assets:precompile
bundle exec rails s -b 0.0.0.0 -e production

# exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

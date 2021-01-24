#!/bin/bash
set -e

cd /var/www/house

RAILS_ENV=production

# Run Rails
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

if [ ! -z $APP_CONTAINER ]; then
  # Run migrations
  bundle exec rake db:migrate

  # Precompile assets
  bundle exec rails assets:clean
  bundle exec rails assets:precompile

  # Run server
  bundle exec rails s -b 0.0.0.0 -e production
fi

if [ ! -z $SIDEKIQ_CONTAINER ]; then
   bundle exec sidekiq
fi

# exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

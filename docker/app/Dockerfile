FROM ruby:3.0.0

ENV RAILS_ROOT /var/www/house
ENV PATH /root/.yarn/bin:$PATH
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle check || bundle install --jobs 20 --without development test

RUN apt-get update -qq && apt-get install -y nodejs
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN bundle exec rails assets:precompile
COPY . .

EXPOSE 3000

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

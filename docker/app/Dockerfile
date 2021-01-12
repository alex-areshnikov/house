FROM ruby:3.0.0

ENV RAILS_ROOT /var/www/house
ENV PATH /root/.yarn/bin:$PATH

RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler -v2.2.4

RUN bundle config set --local without "development test"
RUN bundle install

# Copy project
COPY . .

RUN apt-get update -qq && apt-get install -y nodejs
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN yarn install --check-files

ENV RAILS_ENV=production
RUN bundle exec rails assets:precompile

COPY public public/

EXPOSE 3000

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

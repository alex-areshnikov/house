FROM ruby:2.7.2

ENV RAILS_ROOT /var/www/house
ENV PATH /root/.yarn/bin:$PATH
ENV RAILS_ENV production

RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler -v2.2.4
RUN bundle config set --local without "development test"
RUN bundle install

RUN apt-get update -yq && apt-get upgrade -yq
RUN apt-get install -yq curl

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash
RUN apt-get install -yq nodejs build-essential

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install

RUN mkdir -p tmp/pids

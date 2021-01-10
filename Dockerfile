FROM ruby:3.0.0

ENV PATH /root/.yarn/bin:$PATH

RUN mkdir /house
WORKDIR /house

COPY Gemfile /house/Gemfile
COPY Gemfile.lock /house/Gemfile.lock
RUN bundle check || bundle install

RUN apt-get update -qq && apt-get install -y nodejs
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

COPY . /house
RUN yarn install --check-files
RUN bundle exec rails assets:precompile

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

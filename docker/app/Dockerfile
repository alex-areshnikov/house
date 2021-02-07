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

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 imagemagick libx11-6 libx11-xcb1 libxcb1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -yq && apt-get upgrade -yq
RUN apt-get install -yq curl

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash
RUN apt-get install -yq nodejs build-essential

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install

RUN mkdir -p tmp/pids

# Copy project
COPY . .

EXPOSE 3000

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

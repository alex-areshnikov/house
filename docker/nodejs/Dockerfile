FROM node:14-slim

ENV APP_ROOT /var/www/house
ENV DOCKERIZED true

RUN mkdir -p $APP_ROOT

# Set working directory
WORKDIR $APP_ROOT

RUN apt-get update -y \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 imagemagick libx11-6 libx11-xcb1 libxcb1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install

COPY . .

# Add a script to be executed every time the container starts.
COPY docker/nodejs/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
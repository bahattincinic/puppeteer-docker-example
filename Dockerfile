FROM node:8-slim
RUN apt-get -y update && apt-get -y upgrade

# https://github.com/GoogleChrome/puppeteer/blob/9de34499ef06386451c01b2662369c224502ebe7/docs/troubleshooting.md#running-puppeteer-in-docker
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init


COPY ./*.js ./example/
COPY ./*.json ./example/
WORKDIR example/
RUN npm install

ENTRYPOINT ["dumb-init", "--"]
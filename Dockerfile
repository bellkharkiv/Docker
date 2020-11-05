FROM node:8


COPY . /app/

WORKDIR /app/
ENV PORT=3000
ADD id_rsa /root/.ssh/id_rsa

RUN chmod 600 /root/.ssh/id_rsa && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan bitbucket.org > /root/.ssh/known_hosts && \
    apt update -qqy && \
    apt -qqy install \
    ruby \
    ruby-dev \
    yarn \
    locales \
    autoconf automake gdb git libffi-dev zlib1g-dev libssl-dev \
    build-essential
RUN gem install compass
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN npm ci && \
node ./node_modules/gulp/bin/gulp.js client && \
rm -rf /app/id_rsa \
rm -rf /root/.ssh/


EXPOSE 3000

CMD [ "node", "server.js" ]

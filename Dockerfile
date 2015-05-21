# Inherit from Heroku's stack
FROM heroku/cedar:14

# $HOME is dedicated to mounting or copying in the application
ENV HOME /app/user
# $HEROKU is where the platform is built - binaries like node, ruby, etc
ENV HEROKU /app/heroku
# $PROFILE is a magic directory for Heroku
ENV PROFILE /app/.profile.d
# Internally, we arbitrarily use port 3000
ENV PORT 3000
# Hack to map addons
ENV REDIS_URL="redis://redis:6379"
# Which version of node?
ENV NODE_ENGINE 0.12.2

# Create some needed directories
RUN mkdir -p $HOME $HEROKU $PROFILE
RUN mkdir -p $HEROKU/node

# `init` is kept out of /app so it won't be duplicated on Heroku
# Heroku already has a mechanism for running .profile.d scripts,
# so this is just for local parity
COPY ./init /usr/bin/init

# Install node
RUN curl -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C $HEROKU/node

# Export the node path in .profile.d
RUN echo "export PATH=\"$HEROKU/node/bin:$USER/node_modules/.bin:\$PATH\"" > $PROFILE/nodejs.sh
RUN chmod +x $PROFILE/nodejs.sh

WORKDIR $HOME

ONBUILD ADD ./package.json $HOME/package.json
ONBUILD RUN echo "installing for package.json: $(cat package.json)"
ONBUILD RUN $HEROKU/node/bin/npm install
ONBUILD EXPOSE 3000

ENTRYPOINT ["/usr/bin/init"]

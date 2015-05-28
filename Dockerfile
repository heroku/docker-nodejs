# Inherit from Heroku's stack
FROM heroku/cedar:14

# Internally, we arbitrarily use port 3000
ENV PORT 3000
# Which version of node?
ENV NODE_ENGINE 0.12.2

# Some node modules (like deasync) run 'node' in npm install scripts
# Since the init ENTRYPOINT hasn't been hit yet, they can't find the binary
# Let's sort out a better way, but for now:
ENV PATH /app/heroku/node/bin/:$PATH

# Create some needed directories
RUN mkdir -p /app/heroku/node /app/.profile.d
WORKDIR /app/user

# `init` is kept out of /app so it won't be duplicated on Heroku
# Heroku already has a mechanism for running .profile.d scripts,
# so this is just for local parity
COPY ./init /usr/bin/init

# Install node
RUN curl -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node

# Export the node path in .profile.d
RUN echo "export PATH=\"/app/heroku/node/bin:/app/user/node_modules/.bin:\$PATH\"" > /app/.profile.d/nodejs.sh
RUN chmod +x /app/.profile.d/nodejs.sh

ONBUILD ADD package.json /app/user/
ONBUILD RUN /app/heroku/node/bin/npm install
ONBUILD ADD . /app/user/

ENTRYPOINT ["/usr/bin/init"]

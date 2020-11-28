ARG NODEBB_TAG=latest

FROM nodebb/docker:${NODEBB_TAG}

COPY plugins.lst /
RUN cat /plugins.lst | xargs -n 1 npm install --only=prod && \
    npm cache clean --force

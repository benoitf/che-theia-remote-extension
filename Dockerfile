FROM node:8.12-alpine as builder
RUN apk add --no-cache make gcc g++ python

# Grab dependencies
COPY /package.json /home/theia-endpoint/
RUN cd /home/theia-endpoint/ && yarn install --ignore-scripts

# Compile
COPY *.json /home/theia-endpoint/
COPY /src /home/theia-endpoint/src
RUN cd /home/theia-endpoint/ && yarn install

FROM node:8.12-alpine
# Grab runtime
COPY --from=builder /home/theia-endpoint/node_modules /home/theia/node_modules
COPY --from=builder /home/theia-endpoint/lib /home/theia/lib
CMD node /home/theia/lib/node/plugin-remote.js

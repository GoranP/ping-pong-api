FROM node:22.0.0-slim

RUN mkdir /app
COPY . /app

WORKDIR /app
RUN npm install

EXPOSE 3000

ENTRYPOINT node server.js



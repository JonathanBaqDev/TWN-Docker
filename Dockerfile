FROM node:20-alpine

WORKDIR /home/app

RUN chown -R node:node /home/app

COPY ./app/package.json ./app/package-lock.json ./

USER node

RUN npm ci

COPY ./app ./

CMD ["node", "server.js"]
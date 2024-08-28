FROM node:18

WORKDIR /usr/src/app

COPY ./app/package*.json ./

RUN npm install --production

COPY . .

EXPOSE 80

CMD ["node", "index.js"]
FROM node:10-slim

ENV PORT 5000

# Create app directory
RUN mkdir -p /home/node/app

WORKDIR /home/node/app

# Install app dependencies
COPY package*.json .

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE ${PORT}
VOLUME /home/node/app

ENV NODE_ENV development
CMD [ "npm", "start" ]
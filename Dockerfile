#build stage 继承镜像 指定镜像名 build-stage
FROM node:18.0-alpine3.14 as build-stage

WORKDIR /app

COPY package*.json .

RUN npm config set registry https://registry.npmmirror.com/

RUN npm install

COPY . .

RUN npm run build

#production stage 创建新镜像
FROM node:18.0-alpine3.14 as production-stage

COPY --from=build-stage /app/dist /app

COPY --from=build-stage /app/package.json /app/package.json

WORKDIR /app

RUN npm config set registry https://registry.npmmirror.com/

RUN npm install --production


EXPOSE 3000

CMD ["node", "/app/main.js"]
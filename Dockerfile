# build stage
FROM node:lts-gallium as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY ./ .
RUN npm run build

FROM nginx as production-stage
RUN mkdir /app
COPY --from=build-stage /app/dist /app
COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl-bundle.crt /etc/secrets/tls.crt
COPY tls.key /etc/secrets/tls.key
EXPOSE 443
EXPOSE 80

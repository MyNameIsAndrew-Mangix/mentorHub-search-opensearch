#Stage 1: build the node app
FROM node:21 AS build

# Install git (for branch/patch info)
RUN apt-get update && apt-get install -y git

# Install dependencies
WORKDIR /app
COPY package*.json .
RUN npm install
RUN mkdir dist
COPY . .
COPY ./src/searchinit/entrypoint.sh ./dist
COPY ./src/searchinit/mapping.json ./dist
COPY ./src/searchinit/test-data.json ./dist

RUN npm run build

# Get branch and patch level, then create VERSION.txt file
RUN BRANCH=$(git rev-parse --abbrev-ref HEAD) && \
    PATCH=$(git rev-parse HEAD) && \
    DATE=$(date) && \
    echo $DATE.$BRANCH.$PATCH > ./dist/VERSION.txt

# Stage 2: Run the app in a lightweight image
FROM node:21-alpine as deploy

# Set default ENV values
ENV PROTOCOL=https
ENV HOST=172.17.0.2
ENV AUTH=admin:admin
ENV PORT=9200
ENV ELASTICSEARCH_INDEX=search-index
ENV LOAD_TEST=true

# Copy files from build
WORKDIR /app

COPY --from=build /app/dist .
ENTRYPOINT [ "/bin/sh", "-c", "/app/entrypoint.sh" ]
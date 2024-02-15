#Stage 1: build the node app
FROM node:18 AS build

# Install git (for branch/patch info)
RUN apt-get update && apt-get install -y git

# Install dependencies
WORKDIR /app
COPY package*.json .
RUN npm install

#Copy entrypoint.sh, mapping, and test data
COPY entrypoint.sh mapping.json test-data.json ./dist/

# Build distribution
COPY migrate.ts tsconfig.json ./
RUN npx tsc

#Get branch and patch level, then create VERSION.txt file
RUN DATE=$(date) && \
    echo $DATE.$BRANCH.$PATCH > ./dist/VERSION.txt

# Stage 2: run the app in a lightweight image
#FROM node:18-alpine as deploy
WORKDIR /app/dist
COPY /dist .

#Set default ENV values
ENV PROTOCOL=http
ENV HOST=172.17.0.2
ENV AUTH=admin:admin
ENV PORT=9200
ENV OPENSEARCH_INDEX=search-index
ENV LOAD_TEST=true

ENTRYPOINT [ "/app/dist/entrypoint.sh" ]
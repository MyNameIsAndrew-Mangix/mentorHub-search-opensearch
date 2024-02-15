#Stage 1: build the node app
FROM node:18 AS build

# Install git (for branch/patch info)
RUN apt-get update && apt-get install -y git

# Install dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install

#Copy entrypoint.sh
COPY entrypoint.sh ./dist/

# Build distribution
COPY . .
RUN npx tsc

#Get branch and patch level, then create VERSION.txt file
RUN BRANCH=$(git rev-parse --abbrev-ref HEAD) && \
    PATCH=$(git rev-parse HEAD) && \
    DATE=$(date) && \
    echo $DATE.$BRANCH.$PATCH > ./dist/VERSION.txt

# Stage 2: run the app in a lightweight image
FROM node:18-alpine as deploy
WORKDIR /dist
COPY --from=build /app/dist .

#Set default ENV values
ENV PROTOCOL=http
ENV HOST=localhost
ENV AUTH=admin:admin
ENV PORT=9200
ENV OPENSEARCH_INDEX=search-index
ENV LOAD_TEST=true

ENTRYPOINT [ "./entrypoint.sh" ]
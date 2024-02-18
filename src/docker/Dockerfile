#Stage 1: build the node app
FROM node:18 AS build

# Set default ENV values
ENV PROTOCOL=http
ENV HOST=172.17.0.2
ENV AUTH=admin:admin
ENV PORT=9200
ENV OPENSEARCH_INDEX=search-index
ENV LOAD_TEST=true

# Install git (for branch/patch info)
RUN apt-get update && apt-get install -y git

# Install dependencies
WORKDIR /app
COPY package*.json .
RUN npm install

COPY . .
RUN npm run build


# Get branch and patch level, then create VERSION.txt file - This won't work till we change npm root.
RUN BRANCH=$(git rev-parse --abbrev-ref HEAD) && \
    PATCH=$(git rev-parse HEAD) && \
    DATE=$(date) && \
    echo $DATE.$BRANCH.$PATCH > ./dist/VERSION.txt

# Stage 2: run the app in a lightweight image
FROM node:18 as deploy

# Copy files from Buld
WORKDIR /app
COPY --from=build /app/dist .
COPY --from=build /app/src/opensearch/entrypoint.sh .
COPY --from=build /app/src/opensearch/mapping.json .
COPY --from=build /app/src/opensearch/test-data.json .

CMD ["/bin/bash", "-c", "node ./bundle.js"]
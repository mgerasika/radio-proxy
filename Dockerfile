# Use the official Node.js image as the base image for building the application
FROM node:18 AS builder

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy tsconfig.json
COPY tsconfig.json ./

# Copy the rest of the application code
COPY ./src ./src

# Install TypeScript globally
RUN yarn global add typescript

# Compile TypeScript to JavaScript
RUN tsc

# Use a smaller base image for the final stage
FROM node:18-slim

# Install ffmpeg in the final image
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/src/app

# Copy only the necessary files from the builder stage
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/package.json ./
COPY --from=builder /usr/src/app/yarn.lock ./

# Install production dependencies only
RUN yarn install --production

# Expose the port the app runs on
ARG PORT
EXPOSE ${PORT}

# Start the application
CMD ["node", "dist/index.js"]
